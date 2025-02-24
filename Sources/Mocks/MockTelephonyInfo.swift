#if os(iOS)
import Network
import CoreTelephony

public final class MockTelephonyInfo: TelephonyInfoType {
    public let serviceCurrentRadioAccessTechnology: [String: String]?
    public let currentRadioAccessTechnology: String?

    public init(technologies: [String: String]?, currentTechnology: String? = nil) {
        serviceCurrentRadioAccessTechnology = technologies
        currentRadioAccessTechnology = currentTechnology
    }

    public init(type: ConnectionType.Cellular? = nil) {
        switch type {
        case .cellular2G:
            serviceCurrentRadioAccessTechnology = [
                "2G": CTRadioAccessTechnologyGPRS
            ]
            currentRadioAccessTechnology = CTRadioAccessTechnologyGPRS
        case .cellular3G:
            serviceCurrentRadioAccessTechnology = [
                "3G": CTRadioAccessTechnologyeHRPD
            ]
            currentRadioAccessTechnology = CTRadioAccessTechnologyeHRPD
        case .cellular4G:
            serviceCurrentRadioAccessTechnology = [
                "4G": CTRadioAccessTechnologyLTE
            ]
            currentRadioAccessTechnology = CTRadioAccessTechnologyLTE
        case .cellular5G:
            if #available(iOS 14.1, *) {
                serviceCurrentRadioAccessTechnology = [
                    "5G": CTRadioAccessTechnologyNRNSA
                ]
                currentRadioAccessTechnology = CTRadioAccessTechnologyNRNSA
            } else {
                serviceCurrentRadioAccessTechnology = nil
                currentRadioAccessTechnology = nil
            }
        case .other, .none:
            serviceCurrentRadioAccessTechnology = nil
            currentRadioAccessTechnology = nil
        }
    }
}
#endif
