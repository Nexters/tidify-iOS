//
//  FolderViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/09/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyCore
import TidifyDomain

final class FolderViewModel: ViewModelType {
  typealias UseCase = FolderUseCase

  enum Action: Equatable {
    case viewDidLoad
    case didTapCategory(Folder.FolderCategory)
    case didSelectFolder(_ folder: Folder)
    case didTapDelete(_ folder: Folder)
    case didScroll
  }

  struct State: Equatable {
    var isLoading: Bool
    var category: Folder.FolderCategory
    var folders: [Folder]
    var errorType: FolderError?
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
    switch action {
    case .viewDidLoad:
      setupInitailFolders()
    case .didTapCategory(let category):
      state.category = category
      setupInitailFolders()
    case .didSelectFolder(let folder):
      print("didSelectFolder: \(folder)")
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
        state.isLoading = false
      } catch {
        state.errorType = .failFetchFolderList
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
      }
    }
  }

  func appendFolders(folders: [Folder], addPage: Bool) {
    if addPage {
      currentPage += 1
    }
    state.folders += folders
  }
}
