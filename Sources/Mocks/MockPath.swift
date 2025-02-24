import Network

public final class MockPath: PathType {
    public let status: NWPath.Status
    public let isExpensive: Bool
    public let isConstrained: Bool
    public let availableInterfaceTypes: [NWInterface.InterfaceType]
    public let unsatisfiedReason: NWPath.UnsatisfiedReason

    public init(
        status: NWPath.Status = .satisfied,
        isExpensive: Bool = false,
        isConstrained: Bool = false,
        unsatisfiedReason: NWPath.UnsatisfiedReason = .notAvailable,
        availableInterfaceTypes: NWInterface.InterfaceType...
    ) {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.unsatisfiedReason = unsatisfiedReason
        self.availableInterfaceTypes = availableInterfaceTypes
    }

    public func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool {
        availableInterfaceTypes.contains(type)
    }
}
