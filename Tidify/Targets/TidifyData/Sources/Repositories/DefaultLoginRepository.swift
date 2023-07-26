//
//  DefaultLoginRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import KakaoSDKUser
import TidifyDomain

final class DefaultLoginRepository: LoginRepository {

  // MARK: Properties
  private let networkProvider: NetworkProviderType

  // MARK: Initializer
  init(networkProvider: NetworkProviderType) {
    self.networkProvider = networkProvider
  }
  
  // MARK: Methods
  func appleLogin(token: String) async throws -> UserToken {
    let response = try await networkProvider.request(endpoint: LoginEndpoint.appleLogin(token: token), type: UserTokenDTO.self)

    return response.toDomain()
  }

  func kakaoLogin() async throws -> UserToken {
    try await withCheckedThrowingContinuation { continuation in
      if UserApi.isKakaoTalkLoginAvailable() {
        loginWithKakaoTalk(continuation: continuation)
      } else {
        loginWithKakaoAccount(continuation: continuation)
      }
    }
  }
}

// MARK: - Private
private extension DefaultLoginRepository {
  func loginWithKakaoTalk(continuation: CheckedContinuation<UserToken, Error>) {
    UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
      if let error = error {
        continuation.resume(throwing: error)
        return
      }

      guard let oauthToken = oauthToken,
            let self = self else {
        return
      }

      Task {
        let response = try await self.networkProvider.request(endpoint: LoginEndpoint.kakaoLogin(token: oauthToken.accessToken), type: UserTokenDTO.self)
        continuation.resume(returning: response.toDomain())
      }
    }
  }

  func loginWithKakaoAccount(continuation: CheckedContinuation<UserToken, Error>) {
    UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error in
      if let error = error {
        continuation.resume(throwing: error)
        return
      }

      guard let oauthToken = oauthToken,
            let self = self else {
        return
      }

      Task {
        let response = try await self.networkProvider.request(endpoint: LoginEndpoint.kakaoLogin(token: oauthToken.accessToken), type: UserTokenDTO.self)
        continuation.resume(returning: response.toDomain())
      }
    }
  }
}
