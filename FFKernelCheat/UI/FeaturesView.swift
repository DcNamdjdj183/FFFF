import SwiftUI

struct FeaturesView: View {
    @ObservedObject var config = ConfigManager.shared

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                Form {
                    Section("ESP") {
                        Toggle("EspBox", isOn: binding("EspBox"))
                        Toggle("EspLine", isOn: binding("EspLine"))
                        Toggle("EspName", isOn: binding("EspName"))
                        Toggle("EspHealth", isOn: binding("EspHealth"))
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section("AIM") {
                        Toggle("AimEnabled", isOn: binding("AimEnabled"))
                        Slider(value: floatBinding("AimSmoothness"), in: 0...1) {
                            Text("Smooth \(config.float("AimSmoothness"), specifier: "%.2f")")
                        }
                        Toggle("NoRecoil", isOn: binding("NoRecoil"))
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section("MOVEMENT") {
                        Slider(value: floatBinding("SpeedHack"), in: 1...5) {
                            Text("Speed \(config.float("SpeedHack"), specifier: "%.1f")")
                        }
                    }
                    .listRowBackground(Color.white.opacity(0.05))

                    Section("ANTIBAN") {
                        Toggle("HwidSpoof", isOn: binding("HwidSpoof"))
                        Toggle("MemoryCleaner", isOn: binding("MemoryCleaner"))
                        Toggle("BehaviorRealism", isOn: binding("BehaviorRealism"))
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Features")
        }
    }

    private func binding(_ key: String) -> Binding<Bool> {
        Binding(
            get: { config.bool(key) },
            set: { 
                config.set(key, $0)
                switch key {
                case "AimEnabled": KernelManager.shared.setAimEnabled($0)
                case "EspBox": KernelManager.shared.setEspBox($0)
                case "NoRecoil": KernelManager.shared.setNoRecoil($0)
                case "HwidSpoof": KernelManager.shared.setHwidSpoof($0)
                case "MemoryCleaner": KernelManager.shared.setMemoryCleaner($0)
                default: break
                }
            }
        )
    }

    private func floatBinding(_ key: String) -> Binding<Float> {
        Binding(
            get: { config.float(key) },
            set: { 
                config.set(key, $0)
                if key == "AimSmoothness" { KernelManager.shared.setAimSmoothness($0) }
                if key == "SpeedHack" { KernelManager.shared.setSpeedHack($0) }
            }
        )
    }
}
