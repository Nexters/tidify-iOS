//
//  EndpointType.swift
//  TidifyData
//
//  Created by 여정수 on 2023/07/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import TidifyCore

protocol EndpointType {
  var baseRouthPath: String { get }
  var fullPath: String { get }
  var method: HTTPMethod { get }
  var parameters: [String: String]? { get }
  var headers: [String: String]? { get }

  func makeURLRequest() throws -> URLRequest
}

extension EndpointType {
  var headers: [String: String]? {
    return nil
  }

  func makeURLRequest() throws -> URLRequest {
    var request: URLRequest

    guard NetworkMonitor.shared.isConnected else {
      throw NetworkError.failConnection
    }

    if let parameters {
      switch method {
      case .get:
        guard var components: URLComponents = .init(string: fullPath) else {
          throw NetworkError.invalidURL
        }

        components.queryItems = parameters.map { .init(name: $0.key, value: $0.value) }

        guard let url = components.url else {
          throw NetworkError.invalidURL
        }

        request = .init(url: url)
        request.httpMethod = method.rawValue

      case .post, .put, .delete, .patch:
        guard let url = URL(string: fullPath) else {
          throw NetworkError.invalidURL
        }

        request = .init(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
      }
    } else {
      guard let url = URL(string: fullPath) else {
        throw NetworkError.invalidURL
      }

      request = .init(url: url, timeoutInterval: 5.0)
      request.httpMethod = method.rawValue
    }

    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    if let headers {
      for header in headers {
        request.addValue(header.value, forHTTPHeaderField: header.key)
      }
    } else {
      request.addValue(AppProperties.accessToken, forHTTPHeaderField: "X-Auth-Token")
      request.addValue(AppProperties.refreshToken, forHTTPHeaderField: "refreshToken")
    }
    return request
  }
}
