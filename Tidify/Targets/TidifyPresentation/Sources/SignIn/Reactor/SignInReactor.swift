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
    case trySignIn(type: SocialLoginType)
    case appleSignIn(token: String)
  }

  enum Mutation {
    case setLoading(Bool)
    case successSignIn(type: SocialLoginType)
    case appleSignIn(token: String)
  }

  struct State {
    var isLoading: Bool = false
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .trySignIn(let type):
      return .concat([
        .just(.setLoading(true)),
        usecase.trySignIn(type: type).map { .successSignIn(type: type) },
        .just(.setLoading(false))
      ])

    case .appleSignIn(let token):
      return .concat([
        .just(.setLoading(true)),
        .just(.appleSignIn(token: token)),
      ])
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setLoading(let isLoading):
      newState.isLoading = isLoading

    case .successSignIn(let type):
      newState.isLoading = false
      coordinator.didSuccessSignIn(type: type)

    case .appleSignIn(let token):
      newState.isLoading = false
      AppProperties.authorization = token
      coordinator.didSuccessSignIn(type: .apple)
    }

    return newState
  }
}
