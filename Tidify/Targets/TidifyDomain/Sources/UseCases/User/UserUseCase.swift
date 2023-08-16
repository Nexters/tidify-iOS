//
//  UserUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

public enum UserError: Error {
  case failAppleLogin
  case failKakaoLogin
  case failSignOut
}

public protocol UserUseCase {
  func appleLogin(token: String) async throws -> UserToken
  func kakaoLogin() async throws -> UserToken
  func signOut() async throws

}

final class DefaultUserUseCase: UserUseCase {

  // MARK: Properties
  private let userRepository: UserRepository

  // MARK: Initializer
  public init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }

  // MARK: Methods
  func appleLogin(token: String) async throws -> UserToken {
    try await userRepository.appleLogin(token: token)
  }

  func kakaoLogin() async throws -> UserToken {
    try await userRepository.kakaoLogin()
  }

  func signOut() async throws {
    try await userRepository.signOut()
  }
}
