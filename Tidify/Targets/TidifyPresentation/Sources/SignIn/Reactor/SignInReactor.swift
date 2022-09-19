//
//  SignInReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

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
    case trySignIn(type: SocialLoginType)
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
    case .trySignIn(let type):
      return .concat([
        .just(.setLoading(true)),
        usecase.trySignIn(type: type).map { .setUserToken($0) },
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
      AppProperties.userToken = userToken
      coordinator.didSuccessSignIn()
    }

    return newState
  }
}
