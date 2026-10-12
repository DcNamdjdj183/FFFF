import SwiftUI

struct LogsView: View {
    @ObservedObject var logger = Logger.shared
    @State private var filter: Logger.Level? = nil
    @State private var exportText = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Picker("Filter", selection: $filter) {
                        Text("All").tag(Logger.Level?.none)
                        Text("Info").tag(Logger.Level.info as Logger.Level?)
                        Text("Warn").tag(Logger.Level.warn as Logger.Level?)
                        Text("Error").tag(Logger.Level.error as Logger.Level?)
                        Text("Success").tag(Logger.Level.success as Logger.Level?)
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    ScrollViewReader { proxy in
                        List(filtered) { entry in
                            HStack(alignment: .top) {
                                Text(time(entry.timestamp))
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.gray)
                                Text("[\(entry.level.rawValue)]")
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(color(entry.level))
                                Text(entry.message)
                                    .foregroundColor(color(entry.level))
                            }
                            .id(entry.id)
                        }
                        .hideScrollContentBackground()
                        .onChange(of: logger.logs.count) { _ in
                            if let last = filtered.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }

                    HStack {
                        Button("Clear") { logger.clear() }
                        Button("Export") { exportText = logger.export() }
                    }
                    .padding()
                }
            }
            .navigationTitle("Logs")
        }
    }

    private var filtered: [Logger.LogEntry] {
        guard let f = filter else { return logger.logs }
        return logger.logs.filter { $0.level == f }
    }

    private func time(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f.string(from: d)
    }

    private func color(_ l: Logger.Level) -> Color {
        switch l {
        case .info: return .white
        case .warn: return .yellow
        case .error: return .red
        case .success: return .green
        }
    }
}
