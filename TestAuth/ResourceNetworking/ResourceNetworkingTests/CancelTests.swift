// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Sergey Kharchenko

import XCTest
@testable import ResourceNetworking

class CancelTests: XCTestCase {
	
   func testOCCancel() {
        let cancellation = SimpleCancellation()
		cancellation.isCanceled = false
		let ocCancel = OCCancel(cancel: cancellation)
		ocCancel?.abort()
		XCTAssert(cancellation.isCanceled, "Should be canceled after abort")
	}
}
