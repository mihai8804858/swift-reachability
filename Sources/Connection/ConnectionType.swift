public enum ConnectionType: Hashable, CustomStringConvertible, Sendable {
    #if os(iOS)
    public enum Cellular: Hashable, CustomStringConvertible, Sendable {
        case cellular2G
        case cellular3G
        case cellular4G
        case cellular5G
        case other

        public var description: String {
            switch self {
            case .cellular2G: "Cellular 2G"
            case .cellular3G: "Cellular 3G"
            case .cellular4G: "Cellular 4G"
            case .cellular5G: "Cellular 5G"
            case .other: "Cellular"
            }
        }
    }

    case cellular(Cellular)
    #endif
    case wifi
    case wiredEthernet
    case loopback
    case unknown

    #if os(iOS)
    public var isCellular: Bool {
        guard case .cellular = self else { return false }
        return true
    }
    #endif

    public var isWifi: Bool { self == .wifi }
    public var isWiredEthernet: Bool { self == .wiredEthernet }
    public var isLoopback: Bool { self == .loopback }
    public var isUnknown: Bool { self == .unknown }

    public var description: String {
        switch self {
        #if os(iOS)
        case .cellular(let cellular): cellular.description
        #endif
        case .wifi: "Wi-Fi"
        case .wiredEthernet: "Ethernet"
        case .loopback: "Loopback"
        case .unknown: "Unknown"
        }
    }
}
