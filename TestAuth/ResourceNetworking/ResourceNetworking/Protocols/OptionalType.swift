// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Протоколы для Optional. Необходим для определения Optional в Generic-ах

import Foundation

/// Протокол для Optional
/// - note: Необходим для определения Optional в Generic-ах и ищ
public protocol OptionalType: ExpressibleByNilLiteral {
	associatedtype Wrapped
	var optionalValue: Wrapped? { get }
}

// MARK: - OptionalType
extension Optional: OptionalType {
	public var optionalValue: Wrapped? {
		return self
	}
}
