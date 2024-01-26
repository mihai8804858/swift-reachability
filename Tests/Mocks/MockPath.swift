import Network
@testable import SwiftReachability

final class MockPath: PathType {
    let status: NWPath.Status
    let isExpensive: Bool
    let isConstrained: Bool
    let availableInterfaceTypes: [NWInterface.InterfaceType]
    let unsatisfiedReason: NWPath.UnsatisfiedReason

    init(
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

    let usesInterfaceTypeCheck = FuncCheck<NWInterface.InterfaceType>()
    func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool {
        usesInterfaceTypeCheck.call(type)
        return availableInterfaceTypes.contains(type)
    }
}
