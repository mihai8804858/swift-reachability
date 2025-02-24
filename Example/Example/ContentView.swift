import SwiftUI
import SwiftReachability
import Dependencies

struct ContentView: View {
    let viewModel = ContentViewModel()

    var body: some View {
        Grid(horizontalSpacing: 48) {
            if let image = viewModel.statusIcon {
                GridRow {
                    Text("Status")
                        .gridColumnAlignment(.leading)
                    image
                        .fontWeight(.bold)
                        .foregroundStyle(viewModel.isConnected ? Color.green : Color.red)
                        .gridColumnAlignment(.trailing)
                }
                Divider()
            }

            GridRow {
                Text(viewModel.isConnected ? "Connected via" : "Reason")
                    .gridColumnAlignment(.leading)
                Text(viewModel.status.description)
                    .fontWeight(.bold)
                    .gridColumnAlignment(.trailing)
            }
            Divider()

            GridRow {
                Text("Expensive")
                    .gridColumnAlignment(.leading)
                Text(viewModel.isExpensive ? "Yes" : "No")
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.isExpensive ? Color.red : Color.green)
                    .gridColumnAlignment(.trailing)
            }
            Divider()

            GridRow {
                Text("Constrained")
                    .gridColumnAlignment(.leading)
                Text(viewModel.isConstrained ? "Yes" : "No")
                    .fontWeight(.bold)
                    .foregroundStyle(viewModel.isConstrained ? Color.red : Color.green)
                    .gridColumnAlignment(.trailing)
            }
        }
        .fixedSize()
        .padding()
        .task {
            await viewModel.observeNetwork()
        }
    }
}

#Preview("Live") {
    withDependencies {
        $0.reachability = Reachability()
    } operation: {
        ContentView()
    }
}

#Preview("Connected over cellular") {
    withDependencies {
        $0.reachability = Reachability(monitor: MockPathMonitor(path: MockPath(status: .satisfied, availableInterfaceTypes: .cellular)))
    } operation: {
        ContentView()
    }
}

#Preview("Connected over Wifi") {
    withDependencies {
        $0.reachability = Reachability(monitor: MockPathMonitor(path: MockPath(status: .satisfied, availableInterfaceTypes: .wifi)))
    } operation: {
        ContentView()
    }
}

#Preview("Disconnected") {
    withDependencies {
        $0.reachability = Reachability(monitor: MockPathMonitor(path: MockPath(status: .unsatisfied, unsatisfiedReason: .wifiDenied)))
    } operation: {
        ContentView()
    }
}
