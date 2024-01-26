import Network

public enum DisconnectedReason: Hashable, CustomStringConvertible, Sendable {
    case notAvailable
    case cellularDenied
    case wifiDenied
    case localNetworkDenied
    case vpnInactive

    public var description: String {
        switch self {
        case .notAvailable: "Unknown Reason"
        case .cellularDenied: "Cellular Denied"
        case .wifiDenied: "Wifi Denied"
        case .localNetworkDenied: "Local Network Denied"
        case .vpnInactive: "VPN Inactive"
        }
    }
}

extension NWPath.UnsatisfiedReason {
    var disconnectedReason: DisconnectedReason {
        switch self {
        case .notAvailable: .notAvailable
        case .cellularDenied: .cellularDenied
        case .wifiDenied: .wifiDenied
        case .localNetworkDenied: .localNetworkDenied
        case .vpnInactive: .vpnInactive
        @unknown default: .notAvailable
        }
    }
}
