//
//  NetworkProvider.swift
//  TidifyData
//
//  Created by 여정수 on 2023/07/06.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

protocol NetworkRequestable {
  func data(for urlRequest: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: NetworkRequestable {}

protocol NetworkProviderType: AnyObject {
  @discardableResult
  func request<T: Decodable>(endpoint: EndpointType, type: T.Type) async throws -> T
}

final class NetworkProvider: NetworkProviderType {

  // MARK: Properties
  private let session: NetworkRequestable

  // MARK: Initializer
  init(session: URLSession = .shared) {
    self.session = session
  }

  // MARK: Methods
  @discardableResult
  func request<T: Decodable>(endpoint: EndpointType, type: T.Type) async throws -> T {
    guard NetworkMonitor.shared.isConnected else {
      throw NetworkError.failConnection
    }

    let request: URLRequest = try endpoint.makeURLRequest()
    let (data, response) = try await session.data(for: request)
    try filterNetworkingError(data: data, response: response)

    guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
      throw NetworkError.decodingError
    }

//    guard decoded.isSuccess else {
//      throw NetworkError.unknownError(message: decoded.message)
//    }

    return decoded
  }
}

// MARK: - Private
private extension NetworkProvider {
  func filterNetworkingError(data: Data, response: URLResponse) throws {
    guard let httpResponse = response as? HTTPURLResponse else {
      throw NetworkError.responseError
    }

    guard 200...299 ~= httpResponse.statusCode else {
      throw NetworkError.invalidStatusCode(code: httpResponse.statusCode)
    }

    guard !data.isEmpty else {
      throw NetworkError.emptyData
    }
  }
}
