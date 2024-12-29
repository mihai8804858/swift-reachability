import Network

protocol InterfaceType: Sendable {
    var type: NWInterface.InterfaceType { get }
}

extension NWInterface: InterfaceType {}
