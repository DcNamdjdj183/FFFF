import SwiftUI

struct SettingsView: View {
    @ObservedObject var config = ConfigManager.shared

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Form {
                    Section("Paths") {
                        Text(config.ffConfigPath ?? "FF not found")
                            .font(.system(.caption, design: .monospaced))
                        Text(config.ffMaxConfigPath ?? "FF MAX not found")
                            .font(.system(.caption, design: .monospaced))
                    }
                    Section("Actions") {
                        Button("Reload") { config.load() }
                        Button("Reset to Default") {
                            config.cache = config.defaultConfig()
                            config.save()
                            Logger.shared.log("Reset to default", level: .info)
                        }
                    }
                }
                .hideScrollContentBackground()
            }
            .navigationTitle("Settings")
        }
    }
}
