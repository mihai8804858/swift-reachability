import SwiftUI
import Dependencies
import SwiftReachability

@Observable
class ContentViewModel {
    @ObservationIgnored
    @Dependency(\.reachability) var reachability

    var status: ConnectionStatus = .unknown
    var isConnected: Bool {
        status.isConnected
    }
    var isExpensive: Bool = false
    var isConstrained: Bool = false

    var typeIcon: Image? {
        switch status.connectionType {
#if os(iOS)
        case .cellular: Image(systemName: "cellularbars")
#endif
        case .wifi: Image(systemName: "wifi")
        case .wiredEthernet: Image(systemName: "cable.connector")
        case .loopback: Image(systemName: "point.forward.to.point.capsulepath")
        case .unknown, .none: nil
        }
    }

    var statusIcon: Image? {
        switch status {
        case .connected: typeIcon
        case .disconnected: Image(systemName: "network.slash")
        }
    }

    init() {

    }

    @MainActor
    func observeNetwork() async {
        self.status = await reachability.status
        self.isExpensive = await reachability.isExpensive
        self.isConstrained = await reachability.isConstrained
        
        for await status in await reachability.changes() {
            self.status = status
            self.isExpensive = await reachability.isExpensive
            self.isConstrained = await reachability.isConstrained
        }
    }
}
