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
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
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
    case didScroll
  }
  
  enum Mutation {
    case setupFolders([Folder])
    case pushDetailView(_ folder: Folder)
    case pushEditView(_ folder: Folder)
    case appendFolders([Folder])
    case deleteFolder(_ index: Int)
  }

  struct State {
    var folders: [Folder]
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      currentPage = 0
      return usecase.fetchFolders(start: 0, count: 10)
        .map { [weak self] in
          self?.isLastPage = $0.isLast
          return .setupFolders($0.folders)
        }
      
    case .didSelect(let folder):
      return .just(.pushDetailView(folder))
      
    case .tryEdit(let folder):
      return .just(.pushEditView(folder))
      
    case .tryDelete(let folder):
      return deleteFolder(folder)
      
    case .didScroll:
      guard !isLastPage else { return .empty() }
      return usecase.fetchFolders(start: currentPage, count: 10)
        .map { [weak self] in
          self?.isLastPage = $0.isLast
          return .appendFolders($0.folders)
        }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setupFolders(let folders):
      newState.folders = folders
      currentPage += 1
    case .pushDetailView(let folder):
      coordinator.pushDetailScene(folder: folder)
    case .pushEditView(let folder):
      coordinator.pushEditScene(folder: folder)
    case .appendFolders(let folders):
      newState.folders += folders
      currentPage += 1
    case .deleteFolder(let index):
      newState.folders.remove(at: index)
      return newState
    }

    return newState
  }
}

// MARK: - Private
private extension FolderReactor {
  func deleteFolder(_ folder: Folder) -> Observable<Mutation> {
    guard let index = currentState.folders.firstIndex(where: { $0.id == folder.id })
    else { return .empty() }

    let deleteFolderMutation: Observable<Mutation> = usecase.deleteFolder(id: folder.id)
      .map { .deleteFolder(index) }

    guard !isLastPage else { return deleteFolderMutation }
    let appendFolderMutation: Observable<Mutation> = usecase.fetchFolders(start: currentPage-1, count: 10)
      .map { [weak self] in
        self?.currentPage -= 1
        self?.isLastPage = $0.isLast
        guard let lastFolder = $0.folders.last else { return .appendFolders([]) }
        return .appendFolders([lastFolder])
      }

    return .concat(deleteFolderMutation, appendFolderMutation)
  }
}
