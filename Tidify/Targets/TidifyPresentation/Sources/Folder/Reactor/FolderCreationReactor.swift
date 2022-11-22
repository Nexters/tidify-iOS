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
    case didTapCreateFolderButton(_ folder: FolderRequestDTO)
    case didTapUpdateFolderButton(id: Int, folder: FolderRequestDTO)
  }
  
  enum Mutation {
    case startCreation
  }

  struct State {}

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCreateFolderButton(let folder):
      return usecase.createFolder(requestDTO: folder).map { .startCreation }
    case .didTapUpdateFolderButton(let id, let folder):
      return usecase.updateFolder(id: id, requestDTO: folder).map { .startCreation }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    let newState: State = state

    switch mutation {
    case .startCreation:
      coordinator.popCreationScene()
    }

    return newState
  }
}
