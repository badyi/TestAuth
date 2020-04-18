// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation
@testable import ResourceNetworking

class SimpleCancellation: Cancellation {
	var isCanceled = false
	
	func cancel() {
		isCanceled = true
	}
}
