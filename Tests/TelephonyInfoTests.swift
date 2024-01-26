#if os(iOS)
import XCTest
import CoreTelephony
@testable import SwiftReachability

final class TelephonyInfoTests: XCTestCase {
    func test_currentRadioAccessTechnologies_whenServiceTechnologyAreMissing_shouldReturnEmptySet() {
        let info = MockTelephonyInfo()
        let technologies = info.currentRadioAccessTechnologies
        XCTAssert(technologies.isEmpty)
    }

    func test_currentRadioAccessTechnologies_whenServiceTechnologyArePresent_shouldReturnCorrectValues() {
        let info = MockTelephonyInfo(technologies: [
            "4G": CTRadioAccessTechnologyLTE,
            "3G": CTRadioAccessTechnologyeHRPD
        ])
        let technologies = info.currentRadioAccessTechnologies
        XCTAssertEqual(technologies, [
            CTRadioAccessTechnologyLTE,
            CTRadioAccessTechnologyeHRPD
        ])
    }

    @available(iOS 14.1, *)
    func test_cellularConnectionType_when5GIsSupported_shouldReturn5G() {
        let info = MockTelephonyInfo(technologies: [
            "5G": CTRadioAccessTechnologyNR,
            "4G": CTRadioAccessTechnologyLTE,
            "3G": CTRadioAccessTechnologyWCDMA,
            "2G": CTRadioAccessTechnologyGPRS
        ])
        let cellularConnectionType = info.cellularConnectionType
        XCTAssertEqual(cellularConnectionType, .cellular5G)
    }

    func test_cellularConnectionType_when4GIsSupported_shouldReturn4G() {
        let info = MockTelephonyInfo(technologies: [
            "4G": CTRadioAccessTechnologyLTE,
            "3G": CTRadioAccessTechnologyWCDMA,
            "2G": CTRadioAccessTechnologyGPRS
        ])
        let cellularConnectionType = info.cellularConnectionType
        XCTAssertEqual(cellularConnectionType, .cellular4G)
    }

    func test_cellularConnectionType_when3GIsSupported_shouldReturn3G() {
        let info = MockTelephonyInfo(technologies: [
            "3G": CTRadioAccessTechnologyWCDMA,
            "2G": CTRadioAccessTechnologyGPRS
        ])
        let cellularConnectionType = info.cellularConnectionType
        XCTAssertEqual(cellularConnectionType, .cellular3G)
    }

    func test_cellularConnectionType_when2GIsSupported_shouldReturn2G() {
        let info = MockTelephonyInfo(technologies: [
            "2G": CTRadioAccessTechnologyGPRS
        ])
        let cellularConnectionType = info.cellularConnectionType
        XCTAssertEqual(cellularConnectionType, .cellular2G)
    }

    func test_cellularConnectionType_whenNoneIsSupported_shouldReturnOther() {
        let info = MockTelephonyInfo(technologies: [:])
        let cellularConnectionType = info.cellularConnectionType
        XCTAssertEqual(cellularConnectionType, .other)
    }
}
#endif
