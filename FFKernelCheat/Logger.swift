import Foundation

final class Logger: ObservableObject {
    static let shared = Logger()
    @Published var logs: [LogEntry] = []

    enum Level: String {
        case info = "INFO"
        case warn = "WARN"
        case error = "ERROR"
        case success = "SUCCESS"
    }

    struct LogEntry: Identifiable {
        let id = UUID()
        let timestamp: Date
        let level: Level
        let message: String
    }

    private init() {}

    func log(_ msg: String, level: Level = .info) {
        let entry = LogEntry(timestamp: Date(), level: level, message: msg)
        DispatchQueue.main.async { self.logs.append(entry) }
        print("[\(level.rawValue)] \(msg)")
    }

    func clear() {
        DispatchQueue.main.async { self.logs.removeAll() }
    }

    func export() -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        return logs.map { "[\(fmt.string(from: $0.timestamp))] [\($0.level.rawValue)] \($0.message)" }
            .joined(separator: "\n")
    }
}
