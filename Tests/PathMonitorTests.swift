import Network
import XCTest
@testable import SwiftReachability

final class PathMonitorTests: XCTestCase {
    func test_connectionStatus_whenPathIsNotSatisfied_shouldReturnDisconnected() {
        let path = MockPath(status: .unsatisfied, unsatisfiedReason: .cellularDenied)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .disconnected(.cellularDenied))
    }

    func test_connectionStatus_whenPathIsSatisfied_whenThereIsWiredInterface_shouldReturnCorrectConnection() {
        let monitor = TestMockPathMonitor(path: MockPath())
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wiredEthernet)
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .connected(.wiredEthernet))
    }

    func test_connectionStatus_whenPathIsSatisfied_whenThereIsLoopbackInterface_shouldReturnCorrectConnection() {
        let monitor = TestMockPathMonitor(path: MockPath())
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .loopback)
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .connected(.loopback))
    }

    func test_connectionStatus_whenPathIsSatisfied_whenThereIsWiFiInterface_shouldReturnCorrectConnection() {
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: MockPath())
        #else
        let monitor = TestMockPathMonitor(path: MockPath())
        #endif
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .connected(.wifi))
    }

    func test_connectionStatus_whenPathIsSatisfied_whenThereIsCellularInterface_shouldReturnCorrectConnection() throws {
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: MockPath())
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .cellular)
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .connected(.cellular(.cellular4G)))
        #else
        throw XCTSkip("This test is only available on iOS")
        #endif
    }

    func test_connectionStatus_whenPathIsSatisfied_whenThereIsUnsupportedInterface_shouldReturnCorrectConnection() {
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: MockPath())
        #else
        let monitor = TestMockPathMonitor(path: MockPath())
        #endif
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .other)
        let connectionStatus = monitor.connectionStatus(for: path)
        XCTAssertEqual(connectionStatus, .connected(.unknown))
    }
}
