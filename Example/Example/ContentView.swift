import SwiftUI
import SwiftReachability

struct ContentView: View {
    @ObservedObject private var reachability = Reachability.shared

    var body: some View {
        Grid(horizontalSpacing: 48) {
            if let image = reachability.status.icon {
                GridRow {
                    Text("Status")
                        .gridColumnAlignment(.leading)
                    image
                        .fontWeight(.bold)
                        .foregroundStyle(reachability.status.isConnected ? Color.green : Color.red)
                        .gridColumnAlignment(.trailing)
                }
                Divider()
            }

            GridRow {
                Text(reachability.status.isConnected ? "Connected via" : "Reason")
                    .gridColumnAlignment(.leading)
                Text(reachability.status.description)
                    .fontWeight(.bold)
                    .gridColumnAlignment(.trailing)
            }
            Divider()

            GridRow {
                Text("Expensive")
                    .gridColumnAlignment(.leading)
                Text(reachability.isExpensive ? "Yes" : "No")
                    .fontWeight(.bold)
                    .foregroundStyle(reachability.isExpensive ? Color.red : Color.green)
                    .gridColumnAlignment(.trailing)
            }
            Divider()

            GridRow {
                Text("Constrained")
                    .gridColumnAlignment(.leading)
                Text(reachability.isConstrained ? "Yes" : "No")
                    .fontWeight(.bold)
                    .foregroundStyle(reachability.isConstrained ? Color.red : Color.green)
                    .gridColumnAlignment(.trailing)
            }
        }
        .fixedSize()
        .padding()
    }
}

extension ConnectionType {
    var icon: Image? {
        switch self {
        #if os(iOS)
        case .cellular: Image(systemName: "cellularbars")
        #endif
        case .wifi: Image(systemName: "wifi")
        case .wiredEthernet: Image(systemName: "cable.connector")
        case .loopback: Image(systemName: "point.forward.to.point.capsulepath")
        case .unknown: nil
        }
    }
}

extension ConnectionStatus {
    var icon: Image? {
        switch self {
        case .connected(let connectionType): connectionType.icon
        case .disconnected: Image(systemName: "network.slash")
        }
    }
}

#Preview {
    ContentView()
}
