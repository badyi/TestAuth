// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Протокол для работы с сервером на основе ресурсов

import Foundation

/// Протокол для работы с сервером на основе ресурсов
public protocol NetworkHelperProtocol: class {
	/// Метод загрузки данных на основе Resource(ресурс далее)
	///
	/// - Parameters:
	///   - resource: ресурс
	///   - completion: результат выполнения операции
	/// - Returns: объект отмены операции загрузки данных
	func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation?
}
