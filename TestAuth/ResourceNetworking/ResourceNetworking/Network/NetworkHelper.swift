// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Класс отправки запросов в сеть.

import Foundation

/// Менеджер отправки сетевых запросов, реализует NetworkHelperProtocol
final public class NetworkHelper {
	/// Список ошибок генерируемых NetworkHelper-ом
	///
	/// - noConnection: Ошибка отсутствия сети
	public enum Errors: Error {
		case noConnection
	}
	
	/// Объект проверяющий наличие сети
	private let reachability: ReachabilityProtocol
	/// Объект отсылающий запросы в сеть.
	/// - note: Необходим для тестов, недоступен снаружи
	private let networking: Networking
	
	/// Инициализатор
	///
	/// - Parameter reachability: объект для проверки наличие возможности отправки запроса
	public convenience init(reachability: ReachabilityProtocol) {
		self.init(reachability: reachability, networking: URLSession.shared)
	}
	
	/// Инициализатор
	///
	/// - Parameters:
	///   - reachability: объект для проверки наличие возможности отправки запроса
	///   - networking: объект отсылающий запросы в сеть
	/// - note: Необходим для тестов, недоступен снаружи
	init(reachability: ReachabilityProtocol, networking: Networking) {
		self.reachability = reachability
		self.networking = networking
	}
}

// MARK: - NetworkHelperProtocol
extension NetworkHelper: NetworkHelperProtocol {
	public func load<A>(resource: Resource<A>, completion: @escaping (OperationCompletion<A>) -> ()) -> Cancellation? {
		if !reachability.isReachable {
			completion(.failure(Errors.noConnection))
			return nil
		}
		
		let task = networking.execute(resource) { (data, response, error) in
			if let error = error {
				completion(.failure(error))
			} else {
				do {
					let data = data ?? Data()
					try completion(.success(resource.parse(data)))
				} catch let error {
					completion(.failure(error))
				}
			}
		}
		return task
	}
}
