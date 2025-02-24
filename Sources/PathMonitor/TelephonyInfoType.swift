#if os(iOS)
import CoreTelephony

public protocol TelephonyInfoType: Sendable {
    var serviceCurrentRadioAccessTechnology: [String: String]? { get }
    var currentRadioAccessTechnology: String? { get }
}

#if hasAttribute(retroactive)
extension CTTelephonyNetworkInfo: TelephonyInfoType, @unchecked @retroactive Sendable {}
#else
extension CTTelephonyNetworkInfo: TelephonyInfoType, @unchecked Sendable {}
#endif

public extension TelephonyInfoType {
    var currentRadioAccessTechnologies: Set<String> {
        guard let technology = serviceCurrentRadioAccessTechnology else { return [] }
        return Set(technology.values)
    }

    var cellularConnectionType: ConnectionType.Cellular {
        let currentTechnologies = currentRadioAccessTechnologies
        let connectionType = technologiesMapping
            .sorted { $0.key.priority > $1.key.priority }
            .first { !$0.value.isDisjoint(with: currentTechnologies) }?
            .key

        return connectionType ?? .other
    }

    private var technologiesMapping: [ConnectionType.Cellular: Set<String>] {
        [
            .cellular5G: cellular5GTechnologies,
            .cellular4G: [
                CTRadioAccessTechnologyLTE
            ],
            .cellular3G: [
                CTRadioAccessTechnologyWCDMA,
                CTRadioAccessTechnologyHSDPA,
                CTRadioAccessTechnologyHSUPA,
                CTRadioAccessTechnologyCDMAEVDORev0,
                CTRadioAccessTechnologyCDMAEVDORevA,
                CTRadioAccessTechnologyCDMAEVDORevB,
                CTRadioAccessTechnologyeHRPD
            ],
            .cellular2G: [
                CTRadioAccessTechnologyGPRS,
                CTRadioAccessTechnologyEdge,
                CTRadioAccessTechnologyCDMA1x
            ]
        ]
    }

    private var cellular5GTechnologies: Set<String> {
        guard #available(iOS 14.1, *) else { return [] }
        return [
            CTRadioAccessTechnologyNRNSA,
            CTRadioAccessTechnologyNR
        ]
    }
}

extension ConnectionType.Cellular {
    fileprivate var priority: Int {
        switch self {
        case .cellular5G: 5
        case .cellular4G: 4
        case .cellular3G: 3
        case .cellular2G: 2
        case .other: 1
        }
    }
}
#endif
