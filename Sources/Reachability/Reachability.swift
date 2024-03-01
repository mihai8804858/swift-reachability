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

    public func changesPublisher() -> AnyPublisher<ConnectionStatus, Never> {
        $status
            .removeDuplicates()
            .dropFirst()
            .eraseToAnyPublisher()
    }

    public func changes() -> AsyncStream<ConnectionStatus> {
        changesPublisher()
            .values
            .eraseToStream()
    }

    public func expensiveChangesPublisher() -> AnyPublisher<Bool, Never> {
        $isExpensive
            .removeDuplicates()
            .dropFirst()
            .eraseToAnyPublisher()
    }

    public func expensiveChanges() -> AsyncStream<Bool> {
        expensiveChangesPublisher()
            .values
            .eraseToStream()
    }

    public func constrainedChangesPublisher() -> AnyPublisher<Bool, Never> {
        $isConstrained
            .removeDuplicates()
            .dropFirst()
            .eraseToAnyPublisher()
    }

    public func constrainedChanges() -> AsyncStream<Bool> {
        constrainedChangesPublisher()
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
