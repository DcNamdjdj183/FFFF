import Foundation

final class KernelManager: ObservableObject {
    static let shared = KernelManager()
    private let lock = os_unfair_lock_t.allocate(capacity: 1)
    private var bootAttempts = 0
    private let maxRetries = 3
    @Published var isKernelReady = false
    @Published var isUserlandFallback = false
    @Published var gamePid: Int32 = 0
    @Published var il2cppBase: UInt64 = 0
    private var workerThread: Thread?

    private init() {
        lock.initialize(to: os_unfair_lock())
    }

    deinit { lock.deallocate() }

    func boot() {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        guard !isKernelReady else { return }
        attemptKernel()
    }

    private func attemptKernel() {
        bootAttempts += 1
        let ok = false
        if ok {
            isKernelReady = true
            isUserlandFallback = false
            resolveGame()
            Logger.shared.log("Kernel ready", level: .success)
        } else if bootAttempts < maxRetries {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.attemptKernel()
            }
        } else {
            isUserlandFallback = true
            isKernelReady = false
            Logger.shared.log("Kernel failed — userland fallback", level: .warn)
        }
    }

    func resolveGame() {
        gamePid = 0
        il2cppBase = 0
    }

    func isKaddrValid(_ addr: UInt64) -> Bool {
        addr > 0x100000000 && addr < 0xFFFFFFFFFFFFFFFF
    }

    func pauseThreads() {}
    func killThreads() {
        workerThread?.cancel()
        workerThread = nil
    }

    func reResolveIfNeeded() {
        if gamePid == 0 { resolveGame() }
    }

    func setAimEnabled(_ v: Bool) { ConfigManager.shared.set("AimEnabled", v) }
    func setAimSmoothness(_ v: Float) { ConfigManager.shared.set("AimSmoothness", v) }
    func setEspBox(_ v: Bool) { ConfigManager.shared.set("EspBox", v) }
    func setNoRecoil(_ v: Bool) { ConfigManager.shared.set("NoRecoil", v) }
    func setSpeedHack(_ v: Float) { ConfigManager.shared.set("SpeedHack", v) }
    func setHwidSpoof(_ v: Bool) { ConfigManager.shared.set("HwidSpoof", v) }
    func setMemoryCleaner(_ v: Bool) { ConfigManager.shared.set("MemoryCleaner", v) }
}
