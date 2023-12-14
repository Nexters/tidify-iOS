//
//  BookmarkCreationViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/07.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class BookmarkCreationViewModel: ViewModelType {
  typealias UseCase = BookmarkCreationUseCase

  enum Action {
    case viewDidLoad
    case didTapCreateBookmarkButton(_ requestDTO: BookmarkRequestDTO)
    case didTapUpdateBookmarkButton(id: Int, requestDTO: BookmarkRequestDTO)
    case didScroll
  }

  struct State: Equatable {
    var isLoading: Bool
    var folders: [Folder]
    var isSuccess: Bool
    var bookmarkError: BookmarkCreationError?
    var folderError: FolderListError?
  }

  let useCase: UseCase
  @Published var state: State
  private var currentPage: Int = 0
  private var isLastPage: Bool = false

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, folders: [], isSuccess: false)
  }

  func action(_ action: Action) {
    switch action {
    case .viewDidLoad:
      setupInitailFolders()
    case .didTapCreateBookmarkButton(let requestDTO):
      createBookmark(requestDTO)
    case .didTapUpdateBookmarkButton(let id, let requestDTO):
      updateBookmark(id: id, requestDTO: requestDTO)
    case .didScroll:
      scrollTableView()
    }
  }
}

private extension BookmarkCreationViewModel {
  func setupInitailFolders() {
    Task {
      do {
        state.isLoading = true
        let fetchFolderListResponse = try await useCase.fetchFolderList(start: 0, count: 12, category: .normal)
        isLastPage = fetchFolderListResponse.isLast
        state.folders = fetchFolderListResponse.folders
        currentPage = 1
        state.isLoading = false
      } catch {
        state.folderError = .failFetchFolderList
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

        let fetchFolderListResponse = try await useCase.fetchFolderList(start: currentPage, count: 12, category: .normal)
        isLastPage = fetchFolderListResponse.isLast

        appendFolders(folders: fetchFolderListResponse.folders, addPage: true)
        state.isLoading = false
      } catch {
        state.folderError = .failFetchFolderList
      }
    }
  }

  func appendFolders(folders: [Folder], addPage: Bool) {
    if addPage {
      currentPage += 1
    }
    state.folders += folders
  }

  func createBookmark(_ requestDTO: BookmarkRequestDTO) {
    Task {
      do {
        try await useCase.createBookmark(request: requestDTO)
        state.isSuccess = true
      } catch {
        state.bookmarkError = .failCreateBookmark
      }
    }
  }

  func updateBookmark(id: Int, requestDTO: BookmarkRequestDTO) {
    Task {
      do {
        try await useCase.updateBookmark(id: id, request: requestDTO)
        state.isSuccess = true
      } catch {
        state.bookmarkError = .failUpdateBookmark
      }
    }
  }
}
