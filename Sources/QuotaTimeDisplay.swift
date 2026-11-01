import Foundation

enum QuotaTimeStyle: String, CaseIterable, Identifiable {
    case compact, absolute, precise
    var id: Self { self }
    var title: String {
        switch self {
        case .compact: return "精简倒计时"
        case .absolute: return "具体日期时间"
        case .precise: return "精确倒计时"
        }
    }
    var width: CGFloat { self == .compact ? 58 : 82 }

    private static let clock = formatter("HH:mm")
    private static let calendar = formatter("MMM d HH:mm")
    private static func formatter(_ format: String) -> DateFormatter {
        let value = DateFormatter()
        value.locale = Locale(identifier: "en_US_POSIX")
        value.timeZone = .autoupdatingCurrent
        value.dateFormat = format
        return value
    }

    func text(for date: Date?, weekly: Bool, now: Date = Date()) -> String {
        guard let date else { return "" }
        if self == .absolute { return (weekly ? Self.calendar : Self.clock).string(from: date) }
        let seconds = max(0, Int(date.timeIntervalSince(now)))
        guard seconds > 0 else { return "now" }
        if self == .compact {
            if seconds >= 86_400 { return "\(seconds / 86_400)d later" }
            if seconds >= 3_600 { return "\(seconds / 3_600)h later" }
            return "\(max(1, seconds / 60))m later"
        }
        if weekly {
            let hours = seconds / 3_600
            if hours == 0 { return "<1h later" }
            if hours < 24 { return "\(hours)h later" }
            return "\(hours / 24)d \(hours % 24)h later"
        }
        let minutes = seconds / 60
        if minutes == 0 { return "<1m later" }
        if minutes < 60 { return "\(minutes)m later" }
        return "\(minutes / 60)h \(minutes % 60)m later"
    }
}
