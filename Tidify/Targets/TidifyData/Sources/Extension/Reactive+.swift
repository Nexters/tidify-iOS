//
//  Reactive+.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import TidifyCore

import Moya
import RxSwift

public extension Reactive where Base: MoyaProviderType {

  // MARK: Methods
  func request(_ target: Base.Target) -> Single<Response> {
    let requestSingle = Single.create { [weak base] single in
      let cancellableToken = base?.request(target, callbackQueue: nil, progress: nil) { result in
        switch result {
        case let .success(response):
          updateTokenWhenExpired(response)
          single(.success(response))
        case let .failure(error):
          single(.failure(error))
        }
      }

      return Disposables.create {
        cancellableToken?.cancel()
      }
    }

    return requestSingle
  }

  private func updateTokenWhenExpired(_ response: Response) {
    guard let responseHeaderFields = response.response?.allHeaderFields,
          let updatedAccessTokenData = responseHeaderFields["X-AUTH-TOKEN"] as? Data,
          let updatedRefreshTokenData = responseHeaderFields["refreshToken"] as? Data else {
      return
    }

    KeyChain.save(key: .accessToken, data: updatedAccessTokenData)
    KeyChain.save(key: .refreshToken, data: updatedRefreshTokenData)
  }
}
