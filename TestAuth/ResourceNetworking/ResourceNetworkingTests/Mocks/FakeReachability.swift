// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Автор: Sergey Kharchenko

import Foundation
@testable import ResourceNetworking

class FakeReachability: ReachabilityProtocol {
	var isReachable: Bool
	
	init(isReachable: Bool) {
		self.isReachable = isReachable
	}
}
