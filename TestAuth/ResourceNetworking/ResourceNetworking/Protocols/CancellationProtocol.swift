// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Протокол для объектов которые отменяют операции или какиее-то действия.

import Foundation

/// Протокол отмены операций
public protocol Cancellation {
	// Функция отмены запроса
	func cancel()
}

// Реализация протокола для URLSessionTask(метод cancel() уже есть, реализовывать не надо)
// MARK: - Cancellation
extension URLSessionTask : Cancellation {
	
}

/// Контейнер для отмены запросов, необходим для отмены цепочки запросов, когда объект отмены меняется
final public class RequestCancelContainer {
	/// Реальный объект отмены
	public var requestCancel: Cancellation?
	/// Флаг отменен или нет
	private(set) var isCanceled = false
}

// MARK: - Cancellation
extension RequestCancelContainer: Cancellation {
	public func cancel() {
		isCanceled = true
		requestCancel?.cancel()
	}
}
