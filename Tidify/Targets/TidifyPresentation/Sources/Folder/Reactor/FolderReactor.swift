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
  var initialState: State = .init(folders: [])

  private let coordinator: FolderCoordinator
  private let usecase: FolderUseCase

  init(coordinator: FolderCoordinator, usecase: FolderUseCase) {
    self.coordinator = coordinator
    self.usecase = usecase
  }

  enum Action {
    case viewWillAppear
    case didSelect(_ folder: Folder)
    case tryEdit(_ folder: Folder)
    case tryDelete(_ folder: Folder)
  }
  
  enum Mutation {
    case setupFolders([Folder]?)
    case pushDetailView(_ folder: Folder)
    case pushEditView(_ folder: Folder)
  }

  struct State {
    var folders: [Folder] = []
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return usecase.fetchFolders()
        .map { .setupFolders($0) }
      
    case .didSelect(let folder):
      return .just(.pushDetailView(folder))
      
    case .tryEdit(let folder):
      return .just(.pushEditView(folder))
      
    case .tryDelete(let folder):
      return usecase.deleteFolder(id: folder.id)
        .withLatestFrom(state.map { $0.folders }.asObservable())
        .map { $0.filter { $0.id != folder.id } }
        .map { .setupFolders($0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setupFolders(let folders):
      guard let folders = folders else { break }
      newState.folders = folders
    case .pushDetailView(let folder):
      coordinator.pushDetailScene()
    case .pushEditView(let folder):
      coordinator.pushEditScene()
    }

    return newState
  }
}
