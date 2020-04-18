// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Ресурс содержащий все необходимые параметры для создания и обрабоки запроса

import Foundation

public struct Resource<ResourceType> {
	let url: URL // URL запроса
	let method: HttpMethod<Data> // Метод запроса
	let parse: (Data) throws -> ResourceType // Парсер ответа от сервара
	let headers: [String : String]? // Заголовки запроса
	
	public init(url: URL, method: HttpMethod<Data>, parse: @escaping (Data) throws -> ResourceType, headers: [String : String]? = nil) {
		self.url = url
		self.method = method
		self.parse = parse
		self.headers = headers
	}
}
