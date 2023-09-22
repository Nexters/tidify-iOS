//
//  LoginViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/08/25.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyCore
import TidifyDomain

final class LoginViewModel: ViewModelType {
  typealias UseCase = UserUseCase

  enum Action: Equatable {
    case tryAppleLogin(token: String)
    case tryKakaoLogin
  }

  struct State: Equatable {
    var isLoading: Bool
    var isEntered: Bool
    var errorType: UserError?
  }

  let useCase: UseCase
  @Published var state: State

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, isEntered: false, errorType: nil)
  }

  func action(_ action: Action) {
    Task {
      do {
        state.isLoading = true
        let userToken: UserToken = try await tryLogin(action: action)
        saveTokens(userToken: userToken)
        state.isLoading = false
        state.isEntered = true
      } catch {
        state.errorType = action == .tryKakaoLogin ? .failKakaoLogin : .failAppleLogin
      }
    }
  }
}

private extension LoginViewModel {

  // MARK: Methods
  func saveTokens(userToken: UserToken) {
    if let accessTokenData = userToken.accessToken.data(using: .utf8) {
      KeyChain.save(key: .accessToken, data: accessTokenData)
    }
    if let refreshTokenData = userToken.refreshToken.data(using: .utf8) {
      KeyChain.save(key: .refreshToken, data: refreshTokenData)
    }
  }

  func tryLogin(action: Action) async throws -> UserToken {
    switch action {
    case .tryAppleLogin(let token):
      return try await useCase.appleLogin(token: token)
    case .tryKakaoLogin:
      return try await useCase.kakaoLogin()
    }
  }
}
