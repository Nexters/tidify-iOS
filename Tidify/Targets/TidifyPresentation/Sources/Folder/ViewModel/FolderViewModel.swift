//
//  FolderViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/09/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class FolderViewModel: ViewModelType {
  typealias UseCase = FolderListUseCase

  enum Action: Equatable {
    case initialize
    case didTapCategory(FolderCategory)
    case didTapDelete(_ folder: Folder)
    case didScroll
  }

  struct State: Equatable {
    var isLoading: Bool
    var category: FolderCategory
    var folders: [Folder]
    var errorType: FolderListError?
  }

  let useCase: UseCase
  @Published var state: State
  private var currentPage: Int = 0
  private var isLastPage: Bool = false

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, category: .normal, folders: [], errorType: nil)
  }

  func action(_ action: Action) {
    state.errorType = nil

    switch action {
    case .initialize:
      setupInitailFolders()
    case .didTapCategory(let category):
      state.category = category
      setupInitailFolders()
    case .didTapDelete(let folder):
      deleteFolder(folder)
    case .didScroll:
      scrollTableView()
    }
  }
}

private extension FolderViewModel {
  func setupInitailFolders() {
    Task {
      do {
        state.isLoading = true
        let fetchFolderListResponse = try await useCase.fetchFolderList(start: 0, count: 12, category: state.category)
        isLastPage = fetchFolderListResponse.isLast
        state.folders = fetchFolderListResponse.folders
        currentPage = 1

        if state.category == .normal {
          try await updateFolderSharingState()
        }

        state.isLoading = false
      } catch {
        state.errorType = .failFetchFolderList
        state.isLoading = false
      }
    }
  }

  func deleteFolder(_ folder: Folder) {
    guard let index = state.folders.firstIndex(where: { $0.id == folder.id }) else {
      return
    }

    Task {
      do {
        state.isLoading = true
        try await useCase.deleteFolder(id: folder.id)
        state.folders.remove(at: index)

        if isLastPage {
          state.isLoading = false
          return
        }

        let fetchFolderListResponse = try await useCase.fetchFolderList(start: currentPage-1, count: 12, category: state.category)
        isLastPage = fetchFolderListResponse.isLast

        guard let newFolder = fetchFolderListResponse.folders.last else {
          return
        }

        appendFolders(folders: [newFolder], addPage: false)
        state.isLoading = false
      } catch {
        state.errorType = .failDeleteFolder
        state.isLoading = false
      }
    }
  }

  func scrollTableView() {
    guard !isLastPage else {
      return
    }

    Task {
      do {
        state.isLoading = true

        let fetchFolderListResponse = try await useCase.fetchFolderList(start: currentPage, count: 12, category: state.category)
        isLastPage = fetchFolderListResponse.isLast

        appendFolders(folders: fetchFolderListResponse.folders, addPage: true)
        state.isLoading = false
      } catch {
        state.errorType = .failFetchFolderList
        state.isLoading = false
      }
    }
  }

  func appendFolders(folders: [Folder], addPage: Bool) {
    for folder in folders {
      if state.folders.contains(where: { $0.id == folder.id }) {
        return
      }
      state.folders.append(folder)
    }

    if addPage {
      currentPage += 1
    }
  }

  func updateFolderSharingState() async throws {
    let sharedFolderListResponse = try await useCase.fetchFolderList(start: 0, count: state.folders.count, category: .share)

    for index in state.folders.indices {
      state.folders[index].shared = sharedFolderListResponse.folders.contains(state.folders[index])
    }
  }
}
