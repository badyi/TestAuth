// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Протокол описывающий возможность проверки наличия сети

import Foundation

/// Протокол описывающий возможность проверки наличия сети
public protocol ReachabilityProtocol {
	/// Доступна ли сеть
	var isReachable: Bool { get }
}
