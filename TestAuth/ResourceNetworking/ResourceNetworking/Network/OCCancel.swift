// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Обертка над протоколом Cancellation для ObjC.

import Foundation

/// Класс отмены для возможности отмены из Objective C
@objc final public class OCCancel: NSObject {

	/// Реальный объект отмены
	private let cancel: Cancellation
	
	/// Инициализатор OCCancel
	///
	/// - Parameter cancel: реальный объект отмены из Swift
	public init?(cancel: Cancellation) {
		self.cancel = cancel
		super.init()
	}
	
	/// Отмена операции
	@objc public func abort() -> () {
		self.cancel.cancel()
	}
}
