//
//  FolderDetailViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class FolderDetailViewModel: ViewModelType {
  typealias UseCase = FolderDetailUseCase

  enum Action {
    case initialize(folderID: Int)
    case didTapDelete(_ bookmarkID: Int)
    case didTapStarButton(_ bookmarkID: Int)
    case didTapShareButton
    case didTapStopSharingButton(_ folderID: Int)
    case didTapSubscribeButton(_ folderID: Int)
    case didTapStopSubscriptionButton(_ folderID: Int)
  }

  struct State: Equatable {
    var isLoading: Bool
    var bookmarks: [Bookmark]
    var errorType: BookmarkListError?
  }

  let useCase: UseCase
  @Published var state: State

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, bookmarks: [])
  }

  func action(_ action: Action) {
    state.errorType = nil

    switch action {
    case .initialize(let folderID):
      setupInitailBookmarks(folderID: folderID)
    case .didTapDelete(let bookmarkID):
      deleteBookmark(bookmarkID)
    case .didTapStarButton(let bookmarkID):
      didTapStarButton(bookmarkID)
    case .didTapShareButton:
      //TODO: 구현 예정
      print("didTapShareButton")
    case .didTapStopSharingButton(let folderID):
      didTapStopSharingButton(folderID)
    case .didTapSubscribeButton(let folderID):
      didTapSubscribeButton(folderID)
    case .didTapStopSubscriptionButton(let folderID):
      didTapStopSubscriptionButton(folderID)
    }
  }
}

private extension FolderDetailViewModel {
  func setupInitailBookmarks(folderID: Int) {
    Task {
      do {
        state.isLoading = true
        let fetchBookmarkListResponse = try await useCase.fetchBookmarkListInFolder(id: folderID)
        state.bookmarks = fetchBookmarkListResponse.bookmarks
        state.isLoading = false
      } catch {
        state.errorType = .failFetchBookmarks
        state.isLoading = false
      }
    }
  }

  func deleteBookmark(_ bookmarkID: Int) {
    guard let index = state.bookmarks.firstIndex(where: { $0.id == bookmarkID }) else {
      return
    }

    Task {
      do {
        try await useCase.deleteBookmark(bookmarkID: bookmarkID)
        state.bookmarks.remove(at: index)
      } catch {
        state.errorType = .failDeleteBookmark
      }
    }
  }

  func didTapStarButton(_ bookmarkID: Int) {
    Task {
      do {
        try await useCase.favoriteBookmark(id: bookmarkID)
      } catch {
        state.errorType = .failFavoriteBookmark
      }
    }
  }

  func didTapStopSharingButton(_ folderID: Int) {
    Task {
      try await useCase.stopSharingFolder(id: folderID)
    }
  }

  func didTapSubscribeButton(_ folderID: Int) {
    Task {
      try await useCase.subscribeFolder(id: folderID)
    }
  }

  func didTapStopSubscriptionButton(_ folderID: Int) {
    Task {
      try await useCase.stopSubscription(id: folderID)
    }
  }
}
