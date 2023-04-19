//
//  SignInReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

import ReactorKit

final class SignInReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init()

  private let coordinator: SignInCoordinator
  private let usecase: SignInUseCase

  // MARK: - Initializer
  init(
    coordinator: SignInCoordinator,
    usecase: SignInUseCase
  ) {
    self.coordinator = coordinator
    self.usecase = usecase
  }

  enum Action {
    case tryAppleSignIn(userToken: String)
    case tryKakaoSignIn
  }

  enum Mutation {
    case setLoading(Bool)
    case setUserToken(UserToken)
  }

  struct State {
    var isLoading: Bool = false
    var userToken: UserToken? = nil
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .tryAppleSignIn(let userToken):
      return .concat([
        .just(.setLoading(true)),
        usecase.tryAppleSignIn(token: userToken)
          .map { .setUserToken($0) },
        .just(.setLoading(false))
      ])
    case .tryKakaoSignIn:
      return .concat([
        .just(.setLoading(true)),
        usecase.tryKakaoSignIn().map { .setUserToken($0) },
        .just(.setLoading(false))
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setLoading(let isLoading):
      newState.isLoading = isLoading

    case .setUserToken(let userToken):
      newState.userToken = userToken
      if let accessTokenData = userToken.accessToken.data(using: .utf8) {
        KeyChain.save(key: .accessToken, data: accessTokenData)
      }
      if let refreshTokenData = userToken.refreshToken.data(using: .utf8) {
        KeyChain.save(key: .refreshToken, data: refreshTokenData)
      }
      coordinator.didSuccessSignIn()
    }

    return newState
  }
}
