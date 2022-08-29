//
//  SettingReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import ReactorKit

final class SettingReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init()

  private let coordinaotr: SettingCoordinator

  // MARK: - Initializer
  init(coordinator: SettingCoordinator) {
    self.coordinaotr = coordinator
  }

  enum Action {

  }

  enum Mutation {

  }

  struct State {

  }

  func mutate(action: Action) -> Observable<Mutation> {

  }

  func reduce(state: State, mutation: Mutation) -> State {

  }
}
