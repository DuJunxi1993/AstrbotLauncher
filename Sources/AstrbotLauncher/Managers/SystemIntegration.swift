import Foundation
import AppKit
import SwiftUI
import UserNotifications
import ServiceManagement

/// 登录项管理
@MainActor
final class LoginItemManager {
    static let shared = LoginItemManager()

    /// 检查当前是否注册为登录项
    var isEnabled: Bool {
        SMAppService.mainApp.status == .enabled
    }

    /// 注册 / 取消注册
    func setEnabled(_ enabled: Bool) {
        let service = SMAppService.mainApp
        do {
            if enabled {
                if service.status != .enabled {
                    try service.register()
                }
            } else {
                if service.status == .enabled {
                    try service.unregister()
                }
            }
        } catch {
            AppLog.error("LoginItem error: \(error.localizedDescription)")
        }
    }
}

/// 系统通知
@MainActor
final class NotificationManager {
    static let shared = NotificationManager()

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func send(title: String, body: String) {
        guard AppSettings.shared.enableNotifications else { return }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                AppLog.warn("Notification failed: \(error.localizedDescription)")
            }
        }
    }
}
