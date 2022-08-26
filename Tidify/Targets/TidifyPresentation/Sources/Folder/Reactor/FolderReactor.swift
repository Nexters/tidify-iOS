//
//  FolderReactor.swift
//  TidifyCore
//
//  Created by 한상진 on 2022/08/24.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class FolderReactor: Reactor {
  var initialState: State = .init()

  private let coordinator: FolderCoordinator
  private let usecase: FolderUseCase

  init(coordinator: FolderCoordinator, usecase: FolderUseCase) {
    self.coordinator = coordinator
    self.usecase = usecase
  }

  enum Action {
    case fetchFolders
  }
  
  enum Mutation {
    case setupFolders([Folder]?)
  }

  struct State {
    var folders: [Folder] = []
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchFolders:
      return usecase.fetchFolders()
        .map { .setupFolders($0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case let .setupFolders(folders):
      guard let folders = folders else { break }
      newState.folders = folders
    }

    return newState
  }
}
