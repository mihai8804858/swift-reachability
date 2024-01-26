import Network
import Combine

@MainActor
public final class Reachability: Sendable, ObservableObject {
    public static let shared = Reachability()

    private let monitor: PathMonitorType

    @Published public private(set) var status: ConnectionStatus
    @Published public private(set) var isExpensive: Bool
    @Published public private(set) var isConstrained: Bool

    init(monitor: PathMonitorType = NWPathMonitor()) {
        self.monitor = monitor
        self.status = monitor.connectionStatus(for: monitor.path)
        self.isExpensive = monitor.path.isExpensive
        self.isConstrained = monitor.path.isConstrained
        observeNetworkPathChanges()
    }

    deinit {
        monitor.cancel()
    }

    public func changes() -> AsyncStream<ConnectionStatus> {
        $status
            .removeDuplicates()
            .values
            .eraseToStream()
    }

    public func expensiveChanges() -> AsyncStream<Bool> {
        $isExpensive
            .removeDuplicates()
            .values
            .eraseToStream()
    }

    public func constrainedChanges() -> AsyncStream<Bool> {
        $isConstrained
            .removeDuplicates()
            .values
            .eraseToStream()
    }
}

extension Reachability {
    private func observeNetworkPathChanges() {
        monitor.start(queue: DispatchQueue.global(qos: .utility))
        monitor.onPathUpdate { [weak self] path in
            guard let self else { return }
            status = monitor.connectionStatus(for: path)
            isExpensive = path.isExpensive
            isConstrained = path.isConstrained
        }
    }
}
