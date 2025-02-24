import Dependencies

private enum ReachabilityKey: DependencyKey, Sendable {
    static let liveValue: Reachability = Reachability.shared
}

public extension DependencyValues {
    /// Reachability via swift-dependencies.
    var reachability: Reachability {
        get { self[ReachabilityKey.self] }
        set { self[ReachabilityKey.self] = newValue }
    }
}
