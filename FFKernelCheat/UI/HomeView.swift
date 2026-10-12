import SwiftUI

struct HomeView: View {
    @EnvironmentObject var kernel: KernelManager
    @ObservedObject var config = ConfigManager.shared
    @State private var systemActive = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 16) {
                        statusBadge
                        pathCards
                        openButtons
                        Button("Refresh Paths") {
                            config.refreshPaths()
                            Logger.shared.log("Paths refreshed", level: .info)
                        }
                        .buttonStyle(.borderedProminent)
                        Toggle("system_active", isOn: $systemActive)
                            .onChange(of: systemActive) { config.set("system_active", $0) }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                    .padding()
                }
            }
            .navigationTitle("Home")
        }
        .onAppear { systemActive = config.bool("system_active") }
    }

    private var statusBadge: some View {
        HStack {
            Circle()
                .fill(kernel.isKernelReady ? .green : .red)
                .frame(width: 14, height: 14)
            Text(kernel.isKernelReady ? "Running" : "Not Running")
                .foregroundColor(.white)
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }

    private var pathCards: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("FF: \(config.ffConfigPath ?? "not found")")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)
            Text("FF MAX: \(config.ffMaxConfigPath ?? "not found")")
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }

    private var openButtons: some View {
        VStack(spacing: 12) {
            Button("Mở Free Fire") { openFreeFire() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            Button("Mở Free Fire MAX") { openFreeFireMax() }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
        }
    }

    private func openFreeFire() {
        if let url = URL(string: "freefire://"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            Logger.shared.log("Đã mở Free Fire", level: .success)
        } else {
            Logger.shared.log("FF URL failed — try workspace", level: .warn)
        }
    }

    private func openFreeFireMax() {
        if let url = URL(string: "freefiremax://"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            Logger.shared.log("Đã mở FF MAX", level: .success)
        } else {
            Logger.shared.log("FF MAX URL failed — try workspace", level: .warn)
        }
    }
}
