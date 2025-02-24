import Network

public final class MockPathMonitor: PathMonitorType {
    #if os(iOS)
    public let telephonyNetworkInfo: TelephonyInfoType
    #endif
    public let path: PathType

    #if os(iOS)
    public init(
        telephonyNetworkInfo: TelephonyInfoType = MockTelephonyInfo(),
        path: PathType = MockPath()
    ) {
        self.telephonyNetworkInfo = telephonyNetworkInfo
        self.path = path
    }
    #else
    public init(path: PathType = MockPath()) {
        self.path = path
    }
    #endif

    public func onPathUpdate(_ callback: @escaping @Sendable (PathType) -> Void) { /* No op */ }

    public func start(queue: DispatchQueue) { /* No op */ }

    public func cancel() { /* No op */ }
}
