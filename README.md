
# SwiftReachability

Network reachability based on Apple's [`NWPathMonitor`](https://developer.apple.com/documentation/network/nwpathmonitor).

[![CI](https://github.com/mihai8804858/swift-reachability/actions/workflows/ci.yml/badge.svg)](https://github.com/mihai8804858/swift-reachability/actions/workflows/ci.yml)


## Installation

You can add `swift-reachability` to an Xcode project by adding it to your project as a package.

> https://github.com/mihai8804858/swift-reachability

If you want to use `swift-reachability` in a [SwiftPM](https://swift.org/package-manager/) project, it's as
simple as adding it to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/mihai8804858/swift-reachability", from: "1.0.0")
]
```

And then adding the product to any target that needs access to the library:

```swift
.product(name: "SwiftReachability", package: "swift-reachability"),
```

## Quick Start

* Create an instance of `Reachability`, or use the provided `Reachability.shared` instance:
```swift
private let reachability = Reachability.shared
```
* Check the connection status:
```swift
let isConnected = reachability.status.isConnected
```

```swift
let isDisconnected = reachability.status.isDisconnected
```

```swift
switch reachability.status {
case .connected(let connectionType):
  ...
case .disconnected(let reason):
  ...
}
```

* Check the connection type:

```swift
switch reachability.status.connectionType {
#if os(iOS)
case .cellular(_):
  ...
#endif
case .wifi:
  ...
case .wiredEthernet:
  ...
case .loopback:
  ...
case .unknown:
  ...
}
```

See [ConnectionStatus](Sources/Connection/ConnectionStatus.swift), [ConnectionType](Sources/Connection/ConnectionType.swift) and [DisconnectedReason](Sources/Connection/DisconnectedReason.swift) for more info.

* Check network constraints:

Whether the path uses an interface that is considered expensive, such as Cellular or a Personal Hotspot.
```swift
let isExpensive = reachability.isExpensive
```

Whether the path uses an interface in Low Data Mode.
```swift
let isConstrained = reachability.isConstrained
```

* Listen for changes:

```swift
for await status in networkReachability.changes() {
  ...
}
```

```swift
for await isExpensive in networkReachability.expensiveChanges() {
  ...
}
```

```swift
for await isConstrained in networkReachability.constrainedChanges() {
  ...
}
```

* SwiftUI Support

`Reachability` conforms to `ObservableObject` so it can be easily integrated into SwiftUI `View` and automatically update the UI when status changes:
```swift
struct ContentView: View {
  @ObservedObject private var reachability = Reachability.shared

  var body: some View {
    switch reachability.status {
    case .connected: Text("Connected")
    case .disconnected: Text("Disconnected")
    }
  }
}
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
