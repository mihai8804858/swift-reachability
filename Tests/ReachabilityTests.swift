import XCTest
#if os(iOS)
import CoreTelephony
#endif
@testable import SwiftReachability

final class ReachabilityTests: XCTestCase {
    @MainActor
    func test_isExpensive_shouldReturnCorrectValue() {
        let path = MockPath(status: .satisfied, isExpensive: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let isExpensive = networkReachability.isExpensive
        XCTAssert(isExpensive)
    }

    @MainActor
    func test_isConstrained_shouldReturnCorrectValue() {
        let path = MockPath(status: .satisfied, isConstrained: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let isConstrained = networkReachability.isConstrained
        XCTAssert(isConstrained)
    }

    @MainActor
    func test_status_shouldReturnConnectionStatus() {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let connectionStatus = networkReachability.status
        XCTAssertEqual(connectionStatus, .connected(.wifi))
    }

    @MainActor
    func test_changes_whenConnectionStatusChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let expectation = XCTestExpectation(description: "connection status changed")
        Task.detached {
            for await status in await networkReachability.changes().dropFirst() {
                #if os(iOS)
                XCTAssertEqual(status, .connected(.cellular(.cellular4G)))
                #else
                XCTAssertEqual(status, .connected(.wiredEthernet))
                #endif
                expectation.fulfill()
            }
        }
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            #if os(iOS)
            let newPath = MockPath(status: .satisfied, availableInterfaceTypes: .cellular)
            #else
            let newPath = MockPath(status: .satisfied, availableInterfaceTypes: .wiredEthernet)
            #endif
            monitor.onPathUpdateCheck.argument?(newPath)
        }
        await fulfillment(of: [expectation])
    }

    @MainActor
    func test_changes_whenConnectionStatusDidNotChange_shouldNotNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let expectation = XCTestExpectation(description: "connection status changed")
        Task.detached {
            for await status in await networkReachability.changes().dropFirst() {
                #if os(iOS)
                XCTAssertEqual(status, .connected(.cellular(.cellular4G)))
                #else
                XCTAssertEqual(status, .connected(.wiredEthernet))
                #endif
                expectation.fulfill()
            }
        }
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let newUnchangedPath = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
            monitor.onPathUpdateCheck.argument?(newUnchangedPath)
            #if os(iOS)
            let newChangedPath = MockPath(status: .satisfied, availableInterfaceTypes: .cellular)
            #else
            let newChangedPath = MockPath(status: .satisfied, availableInterfaceTypes: .wiredEthernet)
            #endif
            monitor.onPathUpdateCheck.argument?(newChangedPath)
        }
        await fulfillment(of: [expectation])
    }

    @MainActor
    func test_expensiveChanges_whenCostChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isExpensive: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let expectation = XCTestExpectation(description: "cost changed")
        Task.detached {
            for await isExpensive in await networkReachability.expensiveChanges().dropFirst() {
                XCTAssertFalse(isExpensive)
                expectation.fulfill()
            }
        }
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let newPath = MockPath(status: .satisfied, isExpensive: false)
            monitor.onPathUpdateCheck.argument?(newPath)
        }
        await fulfillment(of: [expectation])
    }

    @MainActor
    func test_constrainedChanges_whenRestrictionsChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isConstrained: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = MockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = MockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        let expectation = XCTestExpectation(description: "restriction changed")
        Task.detached {
            for await isConstrained in await networkReachability.constrainedChanges().dropFirst() {
                XCTAssertFalse(isConstrained)
                expectation.fulfill()
            }
        }
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let newPath = MockPath(status: .satisfied, isConstrained: false)
            monitor.onPathUpdateCheck.argument?(newPath)
        }
        await fulfillment(of: [expectation])
    }
}
