import Foundation

/// WebUI URL 检测通知
extension Notification.Name {
    /// 日志中检测到 WebUI URL
    /// userInfo:
    ///   - "source": LogSource
    ///   - "url": URL
    static let webUIDetected = Notification.Name("WebUIDetected")
}
