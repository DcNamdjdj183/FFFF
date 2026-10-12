import Foundation

final class ConfigManager: ObservableObject {
    static let shared = ConfigManager()

    let ffBundleID = "com.dts.freefireth"
    let ffMaxBundleID = "com.dts.freefiremax"

    @Published var ffConfigPath: String?
    @Published var ffMaxConfigPath: String?
    var cache: [String: Any] = [:]

    private init() {}

    func findContainerByBundleID(_ bundleID: String) -> String? {
        let basePath = "/var/mobile/Containers/Data/Application"
        let fm = FileManager.default
        guard let containers = try? fm.contentsOfDirectory(atPath: basePath) else { return nil }

        for uuid in containers {
            let containerPath = "\(basePath)/\(uuid)"
            let metadataPath = "\(containerPath)/.com.apple.mobile_container_manager.metadata.plist"
            guard let data = fm.contents(atPath: metadataPath),
                  let plist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
                  let identifier = plist["MCMMetadataIdentifier"] as? String,
                  identifier == bundleID else { continue }
            Logger.shared.log("Found container: \(containerPath)", level: .success)
            return containerPath
        }
        Logger.shared.log("No container for \(bundleID)", level: .warn)
        return nil
    }

    func configPath(bundleID: String) -> String? {
        guard let container = findContainerByBundleID(bundleID) else { return nil }
        return "\(container)/Documents/localconfig.json"
    }

    func refreshPaths() {
        ffConfigPath = configPath(bundleID: ffBundleID)
        ffMaxConfigPath = configPath(bundleID: ffMaxBundleID)
        Logger.shared.log("FF path: \(ffConfigPath ?? "nil")")
        Logger.shared.log("FF MAX path: \(ffMaxConfigPath ?? "nil")")
    }

    func load() {
        refreshPaths()
        if let path = ffConfigPath,
           let data = FileManager.default.contents(atPath: path),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            cache = json
            Logger.shared.log("Loaded FF config", level: .success)
        } else {
            cache = defaultConfig()
            Logger.shared.log("Config mới — tạo default", level: .info)
        }
    }

    func save() {
        guard let data = try? JSONSerialization.data(withJSONObject: cache, options: [.prettyPrinted, .sortedKeys]) else { return }
        if let path = ffConfigPath {
            try? data.write(to: URL(fileURLWithPath: path))
            Logger.shared.log("Saved → FF", level: .success)
        }
        if let path = ffMaxConfigPath {
            try? data.write(to: URL(fileURLWithPath: path))
            Logger.shared.log("Saved → FF MAX", level: .success)
        }
    }

    func set(_ key: String, _ value: Any) {
        cache[key] = value
        save()
        Logger.shared.log("Set \(key) = \(value)", level: .info)
    }

    func bool(_ key: String) -> Bool { cache[key] as? Bool ?? false }
    func int(_ key: String) -> Int { cache[key] as? Int ?? 0 }
    func float(_ key: String) -> Float { (cache[key] as? NSNumber)?.floatValue ?? 0 }

    func defaultConfig() -> [String: Any] {
        [
            "EspBox": false, "EspLine": false, "EspName": false,
            "EspHealth": false, "EspDistance": false, "EspSkeleton": false,
            "EspTracer": false, "EspFov": false, "FovSize": 50,
            "AimEnabled": false, "AimSystemEnabled": false,
            "AimTarget": 0, "HeadshotRate": 50, "NoRecoil": false,
            "AimSmoothness": 0.35, "AimFov": 30.0, "AimSpeed": 1.0,
            "SpeedHack": 1, "FastParachute": false, "GhostMode": false,
            "HwidSpoof": false, "MemoryCleaner": false,
            "DetectionKiller": false, "BehaviorRealism": false,
            "BehaviorAimDelay": 200, "BehaviorMissRate": 10,
            "system_active": false
        ]
    }
}
