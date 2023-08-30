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
  typealias Coordinator = LoginCoordinator
  typealias UseCase = UserUseCase

  enum Action {
    case tryAppleLogin(token: String)
    case tryKakaoLogin
  }

  enum State: Equatable {
    case isLoading(Bool)
  }

  private (set) var coordinator: Coordinator
  private (set) var useCase: UseCase
  @Published var state: State

  init(coordinator: Coordinator, useCase: UseCase) {
    self.coordinator = coordinator
    self.useCase = useCase
    state = .isLoading(false)
  }

  func action(_ action: Action) {
    switch action {
    case .tryAppleLogin(let token):
      Task {
        do {
          state = .isLoading(true)
          let token = try await useCase.appleLogin(token: token)
          saveTokens(token)
          state = .isLoading(false)
          coordinator.didSuccessLogin()
        } catch {
          print("error")
        }
      }

    case .tryKakaoLogin:
      state = .isLoading(true)
      Task {
        do {
          state = .isLoading(true)
          let token = try await useCase.kakaoLogin()
          saveTokens(token)
          state = .isLoading(false)
          coordinator.didSuccessLogin()
        } catch {
          print("error")
        }
      }
    }
  }
}

private extension LoginViewModel {

  // MARK: Methods
  func saveTokens(_ userToken: UserToken) {
    if let accessTokenData = userToken.accessToken.data(using: .utf8) {
      KeyChain.save(key: .accessToken, data: accessTokenData)
    }
    if let refreshTokenData = userToken.refreshToken.data(using: .utf8) {
      KeyChain.save(key: .refreshToken, data: refreshTokenData)
    }
  }
}
