import XCTest
@preconcurrency import Combine
#if os(iOS)
import CoreTelephony
#endif
@testable import SwiftReachability

// swiftlint:disable:next type_body_length
final class ReachabilityTests: XCTestCase {
    private var bag = Set<AnyCancellable>()

    override func setUp() {
        super.setUp()

        bag.removeAll()
    }

    func test_isExpensive_shouldReturnCorrectValue() async {
        let path = MockPath(status: .satisfied, isExpensive: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let isExpensive = await networkReachability.isExpensive
        XCTAssert(isExpensive)
    }

    func test_isConstrained_shouldReturnCorrectValue() async {
        let path = MockPath(status: .satisfied, isConstrained: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let isConstrained = await networkReachability.isConstrained
        XCTAssert(isConstrained)
    }

    func test_status_shouldReturnConnectionStatus() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let connectionStatus = await networkReachability.status
        XCTAssertEqual(connectionStatus, .connected(.wifi))
    }

    func test_changes_whenConnectionStatusChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "connection status changed")
        Task.detached {
            for await status in await networkReachability.changes() {
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

    func test_changesPublisher_whenConnectionStatusChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "connection status changed")
        let publisher = await networkReachability.changesPublisher()
        publisher.sink { status in
            #if os(iOS)
            XCTAssertEqual(status, .connected(.cellular(.cellular4G)))
            #else
            XCTAssertEqual(status, .connected(.wiredEthernet))
            #endif
            expectation.fulfill()
        }.store(in: &bag)
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

    func test_changes_whenConnectionStatusDidNotChange_shouldNotNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "connection status changed")
        Task.detached {
            for await status in await networkReachability.changes() {
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

    func test_changesPublisher_whenConnectionStatusDidNotChange_shouldNotNotify() async {
        let path = MockPath(status: .satisfied, availableInterfaceTypes: .wifi)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo(type: .cellular4G)
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "connection status changed")
        let publisher = await networkReachability.changesPublisher()
        publisher.sink { status in
            #if os(iOS)
            XCTAssertEqual(status, .connected(.cellular(.cellular4G)))
            #else
            XCTAssertEqual(status, .connected(.wiredEthernet))
            #endif
            expectation.fulfill()
        }.store(in: &bag)
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

    func test_expensiveChanges_whenCostChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isExpensive: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "cost changed")
        Task.detached {
            for await isExpensive in await networkReachability.expensiveChanges() {
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

    func test_expensiveChangesPublisher_whenCostChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isExpensive: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "cost changed")
        let publisher = await networkReachability.expensiveChangesPublisher()
        publisher.sink { isExpensive in
            XCTAssertFalse(isExpensive)
            expectation.fulfill()
        }.store(in: &bag)
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let newPath = MockPath(status: .satisfied, isExpensive: false)
            monitor.onPathUpdateCheck.argument?(newPath)
        }
        await fulfillment(of: [expectation])
    }

    func test_constrainedChanges_whenRestrictionsChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isConstrained: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "restriction changed")
        Task.detached {
            for await isConstrained in await networkReachability.constrainedChanges() {
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

    func test_constrainedChangesPublisher_whenRestrictionsChanges_shouldNotify() async {
        let path = MockPath(status: .satisfied, isConstrained: true)
        #if os(iOS)
        let mockTelephonyInfo = MockTelephonyInfo()
        let monitor = TestMockPathMonitor(telephonyNetworkInfo: mockTelephonyInfo, path: path)
        #else
        let monitor = TestMockPathMonitor(path: path)
        #endif
        let networkReachability = Reachability(monitor: monitor)
        await Task.yield()
        let expectation = XCTestExpectation(description: "restriction changed")
        let publisher = await networkReachability.constrainedChangesPublisher()
        publisher.sink { isConstrained in
            XCTAssertFalse(isConstrained)
            expectation.fulfill()
        }.store(in: &bag)
        Task {
            try await Task.sleep(nanoseconds: NSEC_PER_SEC)
            let newPath = MockPath(status: .satisfied, isConstrained: false)
            monitor.onPathUpdateCheck.argument?(newPath)
        }
        await fulfillment(of: [expectation])
    }
}
