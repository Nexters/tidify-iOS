//
//  LoginUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

public enum LoginError: Error {
  case failAppleLogin
  case failKakaoLogin
}

public protocol LoginUseCase {
  func appleLogin(token: String) async throws -> UserToken
  func kakaoLogin() async throws -> UserToken
}

final class DefaultLoginUseCase: LoginUseCase {

  // MARK: Properties
  private let loginRepository: LoginRepository

  // MARK: Initializer
  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  // MARK: Methods
  func appleLogin(token: String) async throws -> UserToken {
    try await loginRepository.appleLogin(token: token)
  }

  func kakaoLogin() async throws -> UserToken {
    try await loginRepository.kakaoLogin()
  }
}
