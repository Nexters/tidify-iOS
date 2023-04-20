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
    case viewDidLoad
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
    case .viewDidLoad:
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

  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
    let folderUpdatedEventMutation: Observable<Mutation> = usecase.updatedFolderObservable
      .flatMap { [weak self] updatedFolder -> Observable<Mutation> in
        guard var currentFolder = self?.currentState.folders,
              let folderIdx = currentFolder.firstIndex(where: { $0.id == updatedFolder.id })
        else { return .empty() }

        currentFolder[folderIdx].title = updatedFolder.title
        currentFolder[folderIdx].color = updatedFolder.color
        self?.currentPage -= 1

        return .just(.setupFolders(currentFolder))
      }

    let folderCreatedEventMutation: Observable<Mutation> = usecase.createdFolderObservable
      .flatMap { [weak self] createdFolder -> Observable<Mutation> in
        guard let currentFolder = self?.currentState.folders,
              currentFolder.count < 10
        else { return .empty() }

        self?.currentPage -= 1
        return .just(.appendFolders([createdFolder]))
      }

    return .merge(mutation, folderUpdatedEventMutation, folderCreatedEventMutation)
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
