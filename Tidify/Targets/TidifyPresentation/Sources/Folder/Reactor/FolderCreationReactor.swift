//
//  FolderCreationReactor.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/11/02.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class FolderCreationReactor: Reactor {
  var initialState: State = .init()

  private let coordinator: FolderCoordinator
  private let usecase: FolderUseCase

  init(coordinator: FolderCoordinator, usecase: FolderUseCase) {
    self.coordinator = coordinator
    self.usecase = usecase
  }

  enum Action {
    case createFolderButtonDidTap(_ folder: FolderRequestDTO)
  }
  
  enum Mutation {
    case startCreate(Bool)
  }

  struct State {
    var isCreated = false
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .createFolderButtonDidTap(let folder):
      return usecase.createFolder(requestDTO: folder).map { .startCreate(true) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .startCreate(let isCreated):
      newState.isCreated = isCreated
      coordinator.popCreationScene()
    }

    return newState
  }
}
