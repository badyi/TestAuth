// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Sergey Kharchenko

import XCTest
@testable import ResourceNetworking

class ResourceNetworkingTests: XCTestCase {
	var helper: NetworkHelper!
	var reachability = FakeReachability(isReachable: true)

    override func setUp() {
		helper = NetworkHelper(reachability: reachability, networking: FakeNetworking())
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReachability() {
		reachability.isReachable = false
		
		_ = helper.load(resource: ResourceFactory.failure) { result in
			switch result {
			case .failure(let error):
				XCTAssert(self.isNoConnection(error), "If network is not reachable should be always no connection error")
			case .success:
				XCTFail("Shouldn't be succeded when network is not reachable")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.successEncoded) { result in
			switch result {
			case .failure(let error):
				XCTAssert(self.isNoConnection(error), "If network is not reachable should be always no connection error")
			case .success:
				XCTFail("Shouldn't be succeded when network is not reachable")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.failureWithData) { result in
			switch result {
			case .failure(let error):
				XCTAssert(self.isNoConnection(error), "If network is not reachable should be always no connection error")
			case .success:
				XCTFail("Shouldn't be succeded when network is not reachable")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.parseFailure) { result in
			switch result {
			case .failure(let error):
				XCTAssert(self.isNoConnection(error), "If network is not reachable should be always no connection error")
			case .success:
				XCTFail("Shouldn't be succeded when network is not reachable")
			}
		}
    }
	
	func testResponse() {
		reachability.isReachable = true
		
		_ = helper.load(resource: ResourceFactory.failure) { result in
			switch result {
			case .failure(let error):
				XCTAssert(!self.isNoConnection(error), "Should be error different from no connection")
			case .success:
				XCTFail("Shouldn't be succeded for failure response")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.successEncoded) { result in
			if case let .failure(error) = result {
				XCTFail("Shouldn't be error for success: \(error)")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.failureWithData) { result in
			switch result {
			case .failure(let error):
				XCTAssert(!self.isNoConnection(error), "Should be error different from no connection")
			case .success:
				XCTFail("Shouldn't be succeded for failure response")
			}
		}
		
		_ = helper.load(resource: ResourceFactory.parseFailure) { result in
			switch result {
			case .failure(let error):
				XCTAssert(!self.isNoConnection(error), "Should be error different from no connection")
			case .success:
				XCTFail("Shouldn't be succeded for failure response")
			}
		}
		
	}

	private func isNoConnection(_ error: Error) -> Bool {
		guard let error = error as? NetworkHelper.Errors else {
			return false
		}
		return error == .noConnection
	}

}
