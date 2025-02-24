import Network

public protocol PathType: Sendable {
    var status: NWPath.Status { get }
    var unsatisfiedReason: NWPath.UnsatisfiedReason { get }
    var isExpensive: Bool { get }
    var isConstrained: Bool { get }

    func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool
}

extension NWPath: PathType {}
