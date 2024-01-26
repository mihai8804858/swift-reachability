import XCTest
@testable import SwiftReachability

final class ConnectionTypeTests: XCTestCase {
    func test_isWifi_shouldReturnCorrectValue() {
        XCTAssert(ConnectionType.wifi.isWifi)
        #if os(iOS)
        XCTAssertFalse(ConnectionType.cellular(.cellular5G).isWifi)
        XCTAssertFalse(ConnectionType.cellular(.cellular4G).isWifi)
        XCTAssertFalse(ConnectionType.cellular(.cellular3G).isWifi)
        XCTAssertFalse(ConnectionType.cellular(.cellular2G).isWifi)
        XCTAssertFalse(ConnectionType.cellular(.other).isWifi)
        #endif
        XCTAssertFalse(ConnectionType.wiredEthernet.isWifi)
        XCTAssertFalse(ConnectionType.loopback.isWifi)
        XCTAssertFalse(ConnectionType.unknown.isWifi)
    }

    func test_isCellular_shouldReturnCorrectValue() throws {
        #if os(iOS)
        XCTAssertFalse(ConnectionType.wiredEthernet.isCellular)
        XCTAssertFalse(ConnectionType.wifi.isCellular)
        XCTAssertFalse(ConnectionType.loopback.isCellular)
        XCTAssertFalse(ConnectionType.unknown.isCellular)
        XCTAssert(ConnectionType.cellular(.cellular5G).isCellular)
        XCTAssert(ConnectionType.cellular(.cellular4G).isCellular)
        XCTAssert(ConnectionType.cellular(.cellular3G).isCellular)
        XCTAssert(ConnectionType.cellular(.cellular2G).isCellular)
        XCTAssert(ConnectionType.cellular(.other).isCellular)
        #else
        throw XCTSkip("This test is only supported on iOS")
        #endif
    }

    func test_isWiredEthernet_shouldReturnCorrectValue() {
        XCTAssert(ConnectionType.wiredEthernet.isWiredEthernet)
        XCTAssertFalse(ConnectionType.wifi.isWiredEthernet)
        XCTAssertFalse(ConnectionType.loopback.isWiredEthernet)
        XCTAssertFalse(ConnectionType.unknown.isWiredEthernet)
        #if os(iOS)
        XCTAssertFalse(ConnectionType.cellular(.cellular5G).isWiredEthernet)
        XCTAssertFalse(ConnectionType.cellular(.cellular4G).isWiredEthernet)
        XCTAssertFalse(ConnectionType.cellular(.cellular3G).isWiredEthernet)
        XCTAssertFalse(ConnectionType.cellular(.cellular2G).isWiredEthernet)
        XCTAssertFalse(ConnectionType.cellular(.other).isWiredEthernet)
        #endif
    }

    func test_isLoopback_shouldReturnCorrectValue() {
        XCTAssert(ConnectionType.loopback.isLoopback)
        XCTAssertFalse(ConnectionType.wifi.isLoopback)
        XCTAssertFalse(ConnectionType.wiredEthernet.isLoopback)
        XCTAssertFalse(ConnectionType.unknown.isLoopback)
        #if os(iOS)
        XCTAssertFalse(ConnectionType.cellular(.cellular5G).isLoopback)
        XCTAssertFalse(ConnectionType.cellular(.cellular4G).isLoopback)
        XCTAssertFalse(ConnectionType.cellular(.cellular3G).isLoopback)
        XCTAssertFalse(ConnectionType.cellular(.cellular2G).isLoopback)
        XCTAssertFalse(ConnectionType.cellular(.other).isLoopback)
        #endif
    }

    func test_isUnknown_shouldReturnCorrectValue() {
        XCTAssert(ConnectionType.unknown.isUnknown)
        XCTAssertFalse(ConnectionType.wifi.isUnknown)
        XCTAssertFalse(ConnectionType.wiredEthernet.isUnknown)
        XCTAssertFalse(ConnectionType.loopback.isUnknown)
        #if os(iOS)
        XCTAssertFalse(ConnectionType.cellular(.cellular5G).isUnknown)
        XCTAssertFalse(ConnectionType.cellular(.cellular4G).isUnknown)
        XCTAssertFalse(ConnectionType.cellular(.cellular3G).isUnknown)
        XCTAssertFalse(ConnectionType.cellular(.cellular2G).isUnknown)
        XCTAssertFalse(ConnectionType.cellular(.other).isUnknown)
        #endif
    }
}
