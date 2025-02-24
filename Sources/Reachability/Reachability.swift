import Network
import Combine

public actor Reachability: Sendable, ObservableObject {
    public static let shared = Reachability()

    private let monitor: PathMonitorType

    @Published public private(set) var status: ConnectionStatus = .unknown
    @Published public private(set) var isExpensive: Bool = false
    @Published public private(set) var isConstrained: Bool = false

    public init(monitor: PathMonitorType = NWPathMonitor()) {
        self.monitor = monitor
        Task { [weak self] in
            await self?.networkPathChanged(monitor.path)
            await self?.observeNetworkPathChanges()
        }
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

    // MARK: - Private

    private func observeNetworkPathChanges() {
        monitor.start(queue: DispatchQueue.global(qos: .utility))
        monitor.onPathUpdate { path in
            Task { [weak self] in
                await self?.networkPathChanged(path)
            }
        }
    }

    private func networkPathChanged(_ path: PathType) {
        status = monitor.connectionStatus(for: path)
        isExpensive = path.isExpensive
        isConstrained = path.isConstrained
    }
}
