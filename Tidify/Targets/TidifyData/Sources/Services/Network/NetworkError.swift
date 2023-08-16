//
//  NetworkError.swift
//  TidifyData
//
//  Created by 여정수 on 2023/07/06.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
  case failConnection
  case invalidURL
  case invalidStatusCode(code: Int)
  case emptyData
  case decodingError
  case responseError
  case unknownError(message: String)

  var errorDescription: String? {
    switch self {
    case .failConnection:
      return "네트워크 연결이 불안정해요"
    case .invalidURL:
      return "유효하지 않은 URL이에요"
    case .invalidStatusCode, .responseError:
      return "나중에 다시 시도해주세요"
    case .emptyData:
      return "유효하지 않은 결과에요"
    case .decodingError:
      return "알 수 없는 에러가 발생했어요"
    case .unknownError(let message):
      return message
    }
  }
}
