// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Расширения для протокола Resource в котором добавлена связь с ObjectMapper-om

import Foundation

extension Resource where ResourceType: Decodable {
	public init(url: URL, method: HttpMethod<Data> = .get, headers: [String : String]? = nil) {
		self.url = url
		self.method = method
		self.parse = { data in
			return try JSONDecoder().decode(ResourceType.self, from: data)
		}
		self.headers = headers
	}
}
