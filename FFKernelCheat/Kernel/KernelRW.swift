import Foundation

final class KernelRW {
    static let shared = KernelRW()
    private let lock = os_unfair_lock_t.allocate(capacity: 1)

    private init() { lock.initialize(to: os_unfair_lock()) }
    deinit { lock.deallocate() }

    func read<T>(_ addr: UInt64) -> T? {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        guard KernelManager.shared.isKaddrValid(addr), KernelManager.shared.gamePid > 0 else { return nil }
        // Placeholder: kread via user-pasted exploit
        // return kread(addr) as? T
        return nil
    }

    func write<T>(_ addr: UInt64, value: T) -> Bool {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        guard KernelManager.shared.isKaddrValid(addr), KernelManager.shared.gamePid > 0 else { return false }
        // Placeholder: kwrite via user-pasted exploit
        // kwrite(addr, value)
        return true
    }

    func readBytes(_ addr: UInt64, count: Int) -> Data? {
        os_unfair_lock_lock(lock)
        defer { os_unfair_lock_unlock(lock) }
        guard KernelManager.shared.isKaddrValid(addr) else { return nil }
        return nil
    }
}
