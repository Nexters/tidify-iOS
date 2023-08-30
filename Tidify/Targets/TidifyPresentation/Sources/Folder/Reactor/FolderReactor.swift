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
  private weak var coordinator: FolderCoordinator?
  private let useCase: FolderUseCase

  init(coordinator: FolderCoordinator, useCase: FolderUseCase) {
    self.coordinator = coordinator
    self.useCase = useCase
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
    case appendFolders(folders: [Folder], addPage: Bool)
    case updateFolder(folderIdx: Int, folder: Folder)
    case deleteFolder(_ index: Int)
  }

  struct State {
    var folders: [Folder]
  }

  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//    case .viewDidLoad:
//      return useCase.fetchFolders(start: 0, count: 10)
//        .map { [weak self] in
//          self?.setLastPage($0.isLast)
//          return .setupFolders($0.folders)
//        }
//
//    case .didSelect(let folder):
//      return .just(.pushDetailView(folder))
//
//    case .tryEdit(let folder):
//      return .just(.pushEditView(folder))
//
//    case .tryDelete(let folder):
//      return deleteFolder(folder)
//
//    case .didScroll:
//      guard !isLastPage else {
//        return .empty()
//      }
//      return useCase.fetchFolders(start: currentPage, count: 10)
//        .map { [weak self] in
//          self?.setLastPage($0.isLast)
//          return .appendFolders(folders: $0.folders, addPage: true)
//        }
//    }
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setupFolders(let folders):
      newState.folders = folders
      currentPage += 1

    case .pushDetailView(let folder):
      coordinator?.pushDetailScene(folder: folder)

    case .pushEditView(let folder):
      coordinator?.pushFolderEditScene(folder: folder)

    case .appendFolders(let folders, let addPage):
      if addPage {
        currentPage += 1
      }
      newState.folders += folders

    case .updateFolder(let idx, let folder):
      newState.folders[idx] = folder

    case .deleteFolder(let index):
      newState.folders.remove(at: index)
    }

    return newState
  }

//  func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//    let folderUpdatedEventMutation: Observable<Mutation> = useCase.updatedFolderObservable
//      .flatMap { [weak self] updatedFolder -> Observable<Mutation> in
//        guard let folderIdx = self?.currentState.folders.firstIndex(where: { $0.id == updatedFolder.id }) else {
//          return .empty()
//        }
//
//        return .just(.updateFolder(folderIdx: folderIdx, folder: updatedFolder))
//      }
//
//    let folderCreatedEventMutation: Observable<Mutation> = useCase.createdFolderObservable
//      .withUnretained(self)
//      .filter { owner, _ in
//        owner.isLastPage
//      }
//      .flatMap { _, createdFolder -> Observable<Mutation> in
//        .just(.appendFolders(folders: [createdFolder], addPage: false))
//      }
//
//    return .merge(mutation, folderUpdatedEventMutation, folderCreatedEventMutation)
//  }
}

// MARK: - Private
private extension FolderReactor {
  func setLastPage(_ isLast: Bool) {
    isLastPage = isLast
  }

//  func deleteFolder(_ folder: Folder) -> Observable<Mutation> {
//    guard let index = currentState.folders.firstIndex(where: { $0.id == folder.id }) else {
//      return .empty()
//    }
//
//    let deleteFolderMutation: Observable<Mutation> = useCase.deleteFolder(id: folder.id)
//      .map { .deleteFolder(index) }
//
//    guard !isLastPage else {
//      return deleteFolderMutation
//    }
//
//    let appendFolderMutation: Observable<Mutation> = useCase.fetchFolders(start: currentPage-1, count: 10)
//      .filter { [weak self] in
//        self?.setLastPage($0.isLast)
//        return $0.folders.last != nil
//      }
//      .map { .appendFolders(folders: [$0.folders.last!], addPage: false) }
//
//    return .concat(deleteFolderMutation, appendFolderMutation)
//  }
}
