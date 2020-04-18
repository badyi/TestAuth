// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Доступные типы запросов

import Foundation

/// Тип запроса
///
/// - get GET-запрос
/// - post POST-зпрос, передаваемый параметр типа Body - тело запроса(HTTPBody)
public enum HttpMethod<Body> {
	case get
	case post(Body)
}

extension HttpMethod {
	/// Строковое значение, используется для передачи в запрос
	var stringValue: String{
		switch self {
		case .get:
			return "GET"
		case .post:
			return "POST"
		}
	}
	
	/// Маппер одного типа тела в другой
	///
	/// - Parameter f: функция трансляции типа Body в тип B
	/// - Returns: возвращает HttpMethod с новым типом B
	func map<B>(f: (Body) -> B) -> HttpMethod<B> {
		switch self {
		case .get:
			return .get
		case .post(let body):
			return .post(f(body))
		}
	}
}
