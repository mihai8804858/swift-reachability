public enum ConnectionStatus: Hashable, CustomStringConvertible, Sendable {
    case connected(ConnectionType)
    case disconnected(DisconnectedReason)

    public static let unknown = ConnectionStatus.disconnected(.notAvailable)

    public var isConnected: Bool {
        guard case .connected = self else { return false }
        return true
    }

    public var connectionType: ConnectionType? {
        guard case .connected(let type) = self else { return nil }
        return type
    }

    public var isDisconnected: Bool {
        guard case .disconnected = self else { return false }
        return true
    }

    public var disconnectedReason: DisconnectedReason? {
        guard case .disconnected(let reason) = self else { return nil }
        return reason
    }

    public var description: String {
        switch self {
        case .connected(let connectionType): connectionType.description
        case .disconnected(let reason): reason.description
        }
    }
}
