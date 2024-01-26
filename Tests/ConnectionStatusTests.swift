import XCTest
@testable import SwiftReachability

final class ConnectionStatusTests: XCTestCase {
    func test_isConnected_whenIsConnected_shouldReturnTrue() {
        let status = ConnectionStatus.connected(.wifi)
        XCTAssert(status.isConnected)
    }

    func test_isConnected_whenIsDisconnected_shouldReturnFalse() {
        let status = ConnectionStatus.disconnected(.wifiDenied)
        XCTAssertFalse(status.isConnected)
    }

    func test_connectionType_whenIsConnected_shouldReturnType() {
        let status = ConnectionStatus.connected(.wifi)
        XCTAssertEqual(status.connectionType, .wifi)
    }

    func test_connectionType_whenIsDisconnected_shouldReturnNil() {
        let status = ConnectionStatus.disconnected(.localNetworkDenied)
        XCTAssertNil(status.connectionType)
    }

    func test_isDisconnected_whenIsDisconnected_shouldReturnTrue() {
        let status = ConnectionStatus.disconnected(.cellularDenied)
        XCTAssert(status.isDisconnected)
    }

    func test_isDisconnected_whenIsConnected_shouldReturnFalse() {
        let status = ConnectionStatus.connected(.wiredEthernet)
        XCTAssertFalse(status.isDisconnected)
    }

    func test_disconnectedReason_whenIsDisconnected_shouldReturnReason() {
        let status = ConnectionStatus.disconnected(.cellularDenied)
        XCTAssertEqual(status.disconnectedReason, .cellularDenied)
    }

    func test_disconnectedReason_whenIsConnected_shouldReturnNil() {
        let status = ConnectionStatus.connected(.loopback)
        XCTAssertNil(status.disconnectedReason)
    }
}
