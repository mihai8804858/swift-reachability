import Network
@testable import SwiftReachability

final class TestMockPathMonitor: PathMonitorType {
#if os(iOS)
    let telephonyNetworkInfo: TelephonyInfoType
#endif
    let path: PathType

#if os(iOS)
    init(
        telephonyNetworkInfo: TelephonyInfoType = MockTelephonyInfo(),
        path: PathType = MockPath()
    ) {
        self.telephonyNetworkInfo = telephonyNetworkInfo
        self.path = path
    }
#else
    init(path: PathType = MockPath()) {
        self.path = path
    }
#endif

    let onPathUpdateCheck = FuncCheck<@Sendable (PathType) -> Void>()
    func onPathUpdate(_ callback: @escaping @Sendable (PathType) -> Void) {
        onPathUpdateCheck.call(callback)
    }

    let startCheck = FuncCheck<DispatchQueue>()
    func start(queue: DispatchQueue) {
        startCheck.call(queue)
    }

    let cancelCheck = FuncCheck<Void>()
    func cancel() {
        cancelCheck.call()
    }
}
