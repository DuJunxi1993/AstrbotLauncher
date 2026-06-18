import Foundation

/// AstrBot 进程生命周期管理器
///
/// 职责：
/// - 启动 AstrBot（daemon 化，子进程脱离 app 进程组）
/// - 停止 AstrBot（先 SIGTERM，5 秒后 SIGKILL）
/// - 查询 AstrBot 状态（pgrep）
/// - 检测孤儿 AstrBot 实例并清理
@MainActor
final class AstrBotProcessManager {
    /// 已知 PID（最近一次本 app 启动的 AstrBot）
    private(set) var knownPID: pid_t?

    /// 是否由本 app 启动
    private(set) var startedByUs: Bool = false

    /// 启动 AstrBot（daemon 化）
    @discardableResult
    func start() throws -> pid_t {
        // 1. 先清理孤儿实例
        try? cleanupOrphans()

        // 2. 构建启动命令
        let settings = AppSettings.shared
        let mode = settings.astrBotLaunchMode
        let (executable, args) = try buildLaunchCommand(mode: mode, settings: settings)
        AppLog.info("AstrBot start: executable=\(executable) args=\(args)")

        // 3. 工作目录：AstrBot 期望在 data 目录的**父目录**运行
        //    （即 <project_root>，data/ 在它下面）
        let dataDir = (settings.dataDirectory as NSString).expandingTildeInPath
        let parent = (dataDir as NSString).deletingLastPathComponent
        let workingDirectory: String? = FileManager.default.fileExists(atPath: parent) ? parent : nil
        AppLog.info("AstrBot start: dataDir=\(dataDir) cwd=\(workingDirectory ?? "inherit")")

        // 4. spawn daemon
        guard let pid = ProcessSpawner.spawnDaemon(
            executable: executable,
            arguments: args,
            workingDirectory: workingDirectory
        ) else {
            throw NSError(
                domain: "AstrBotProcessManager",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "无法启动 AstrBot"]
            )
        }

        knownPID = pid
        startedByUs = true
        AppLog.info("AstrBot started: pid=\(pid)")
        return pid
    }

    /// 停止 AstrBot
    func stop() {
        if let pid = knownPID {
            kill(pid, SIGTERM)
            // 5 秒后强杀
            Task {
                try? await Task.sleep(nanoseconds: 5_000_000_000)
                if kill(pid, 0) == 0 {  // 进程仍在
                    kill(pid, SIGKILL)
                }
            }
        } else {
            // 不知道 PID，用 pkill
            _ = ShellExecutor.runSync("/usr/bin/pkill", arguments: ["-f", "astrbot run"])
        }
        knownPID = nil
        startedByUs = false
    }

    /// 查询 AstrBot 是否在运行（pgrep）
    func isRunning() -> Bool {
        let result = ShellExecutor.runSync("/usr/bin/pgrep", arguments: ["-f", "astrbot run"])
        // pgrep 在有匹配时返回 0（stdout 有内容）
        if !result.success { return false }
        // 排除自己（pgrep 自身）和 grep 进程
        return result.stdout.split(separator: "\n").contains { line in
            !line.contains("pgrep")
        }
    }

    /// 获取 AstrBot 当前 PID
    func currentPID() -> pid_t? {
        let result = ShellExecutor.runSync("/usr/bin/pgrep", arguments: ["-fn", "astrbot run"])
        guard result.success else { return nil }
        // 解析第一行：PID
        guard let firstLine = result.stdout.split(separator: "\n").first else { return nil }
        let parts = firstLine.split(separator: " ", omittingEmptySubsequences: true)
        guard let pidStr = parts.first, let pid = pid_t(pidStr) else { return nil }
        return pid > 0 ? pid : nil
    }

    /// 获取所有 AstrBot 实例
    func allInstances() -> [(pid: pid_t, elapsed: String)] {
        let result = ShellExecutor.runSync("/usr/bin/pgrep", arguments: ["-fl", "astrbot run"])
        guard result.success else { return [] }
        return result.stdout.split(separator: "\n").compactMap { line -> (pid_t, String)? in
            // 排除 pgrep 自身
            if line.contains("pgrep") { return nil }
            let parts = line.split(separator: " ", omittingEmptySubsequences: true)
            guard parts.count >= 2,
                  let pid = pid_t(parts[0]) else { return nil }
            let elapsed = parts.dropFirst().dropLast().joined(separator: " ")
            return (pid, elapsed)
        }
    }

    /// 清理孤儿实例（保留最老的）
    func cleanupOrphans() throws {
        let instances = allInstances()
        guard instances.count > 1 else { return }

        // 保留 PID 最小的（最早启动的）
        let keep = instances.min(by: { $0.pid < $1.pid })!
        for inst in instances where inst.pid != keep.pid {
            kill(inst.pid, SIGTERM)
        }
        AppLog.info("Cleaned up \(instances.count - 1) orphan AstrBot instances, kept PID \(keep.pid)")
    }

    /// 构建启动命令（参考 AstrBotController.buildLaunchCommand）
    private func buildLaunchCommand(mode: AstrBotLaunchMode, settings: AppSettings) throws -> (String, [String]) {
        switch mode {
        case .uvToolRun:
            guard let astrbotPath = AstrBotController.detectAstrbotPath() else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 1,
                    userInfo: [NSLocalizedDescriptionKey: "未找到 astrbot 命令"]
                )
            }
            return (astrbotPath, ["run"])
        case .customCommand:
            let command = settings.astrBotCustomCommand.trimmingCharacters(in: .whitespaces)
            guard !command.isEmpty else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 2,
                    userInfo: [NSLocalizedDescriptionKey: "请先在设置中输入自定义命令"]
                )
            }
            return ShellParser.parse(command)
        case .executablePath:
            let path = settings.astrBotExecutablePath.trimmingCharacters(in: .whitespaces)
            guard !path.isEmpty else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 3,
                    userInfo: [NSLocalizedDescriptionKey: "请先在设置中指定 AstrBot 可执行文件路径"]
                )
            }
            let expandedPath = (path as NSString).expandingTildeInPath
            guard ShellExecutor.exists(expandedPath) else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 4,
                    userInfo: [NSLocalizedDescriptionKey: "文件不存在: \(expandedPath)"]
                )
            }
            return (expandedPath, [])
        case .shellScript:
            let path = settings.astrBotScriptPath.trimmingCharacters(in: .whitespaces)
            guard !path.isEmpty else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 5,
                    userInfo: [NSLocalizedDescriptionKey: "请先在设置中指定启动脚本路径"]
                )
            }
            let expandedPath = (path as NSString).expandingTildeInPath
            guard ShellExecutor.exists(expandedPath) else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 6,
                    userInfo: [NSLocalizedDescriptionKey: "脚本不存在: \(expandedPath)"]
                )
            }
            guard let bash = ShellExecutor.which("bash") else {
                throw NSError(
                    domain: "AstrBotProcessManager",
                    code: 7,
                    userInfo: [NSLocalizedDescriptionKey: "未找到 bash"]
                )
            }
            return (bash, [expandedPath])
        }
    }
}
