import Network

protocol InterfaceType {
    var type: NWInterface.InterfaceType { get }
}

extension NWInterface: InterfaceType {}
