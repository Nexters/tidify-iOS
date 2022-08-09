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

  struct State {
    var successSignIn: Bool = false
  }

  func mutate(action: Action) -> Observable<Action> {
    switch action {
    case .trySignIn(let type):
      return usecase.trySignIn(type: type)
        .map { .trySignIn(type: type) }
    }
  }

  func reduce(state: State, mutation: Action) -> State {
    var newState: State = state

    switch mutation {
    case .trySignIn(let type):
      newState.successSignIn = true
      coordinator.didSuccessSignIn(type: type)
    }

    return newState
  }
}
