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

  struct State {
    var successSignIn: Bool = false
  }

  func mutate(action: Action) -> Observable<Action> {
    switch action {
    case .trySignIn(let type):
      return usecase.trySignIn(type: type)
        .map { .trySignIn(type: type) }
    case .appleSignIn(let token):
      return .just(.appleSignIn(token: token))
    }
  }

  func reduce(state: State, mutation: Action) -> State {
    var newState: State = state

    switch mutation {
    case .trySignIn(let type):
      newState.successSignIn = true
      coordinator.didSuccessSignIn(type: type)
    case .appleSignIn(let token):
      AppProperties.authorization = token
      newState.successSignIn = true
      coordinator.didSuccessSignIn(type: .apple)
    }

    return newState
  }
}
