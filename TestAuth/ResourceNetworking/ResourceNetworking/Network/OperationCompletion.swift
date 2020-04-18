// Copyright (C) Sergey Kharchenko, 2019 . All rights reserved.
// Описание: Результат выполнения операции

import Foundation

/// Результат выполнения операции
///
/// - success: успешно, возвращает результат ответа с типом ResponseType
/// - failure: ошибка, возвращает ошибку
public enum OperationCompletion<ResponseType>{
	case success(ResponseType)
	case failure(Error)
}
