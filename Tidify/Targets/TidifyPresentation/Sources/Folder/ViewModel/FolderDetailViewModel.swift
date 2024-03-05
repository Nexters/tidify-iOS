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
    case initialize(folderID: Int, subscribe: Bool)
    case didTapDelete(_ bookmarkID: Int)
    case didTapStarButton(_ bookmarkID: Int)
    case didTapLeftButton(_ folderID: Int)
    case didTapRightButton(_ folderID: Int)
  }

  struct State: Equatable {
    var isLoading: Bool
    var bookmarks: [Bookmark]
    var bookmarkErrorType: BookmarkListError?
    var folderSubscriptionErrorType: FolderSubscriptionError?
    var viewMode: FolderDetailViewMode
  }

  let useCase: UseCase
  @Published var state: State

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, bookmarks: [], viewMode: .ownerNotSharing)
  }

  func action(_ action: Action) {
    state.bookmarkErrorType = nil
    state.folderSubscriptionErrorType = nil

    switch action {
    case .initialize(let folderID, let subscribe):
      setupViewMode(folderID: folderID)
      setupInitailBookmarks(folderID: folderID, subscribe: subscribe)
    case .didTapDelete(let bookmarkID):
      deleteBookmark(bookmarkID)
    case .didTapStarButton(let bookmarkID):
      didTapStarButton(bookmarkID)
    case .didTapLeftButton(let folderID):
      didTapLeftButton(folderID)
    case .didTapRightButton(let folderID):
      didTapRightButton(folderID)
    }
  }
}

private extension FolderDetailViewModel {
  func setupViewMode(folderID: Int) {
    Task {
      do {
        state.isLoading = true
        let fetchFolderListResponse = try await useCase.fetchFolderList(start: 0, count: 0, category: .normal)

        for folder in fetchFolderListResponse.folders where folder.id == folderID {
          try await fetchSharingFolderList(folderID: folderID)
          return
        }

        try await fetchSubscribingFolderList(folderID: folderID)
        state.isLoading = false
      } catch {
        state.bookmarkErrorType = .failFetchBookmarks
        state.isLoading = false
      }
    }
  }

  func fetchSharingFolderList(folderID: Int) async throws {
    let fetchSharingFolderListResponse = try await useCase.fetchFolderList(start: 0, count: 0, category: .share)

    for folder in fetchSharingFolderListResponse.folders where folder.id == folderID {
      state.viewMode = .owner
      return
    }

    state.viewMode = .ownerNotSharing
  }

  func fetchSubscribingFolderList(folderID: Int) async throws {
    let fetchSubscribingFolderListResponse = try await useCase.fetchFolderList(start: 0, count: 0, category: .subscribe)

    for folder in fetchSubscribingFolderListResponse.folders where folder.id == folderID {
      state.viewMode = .subscriber
      return
    }

    state.viewMode = .subscribeNotSubscribe
  }

  func setupInitailBookmarks(folderID: Int, subscribe: Bool) {
    Task {
      do {
        state.isLoading = true
        let fetchBookmarkListResponse = try await useCase.fetchBookmarkListInFolder(id: folderID, subscribe: subscribe)
        state.bookmarks = fetchBookmarkListResponse.bookmarks
        state.isLoading = false
      } catch {
        state.bookmarkErrorType = .failFetchBookmarks
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
        state.bookmarkErrorType = .failDeleteBookmark
      }
    }
  }

  func didTapStarButton(_ bookmarkID: Int) {
    Task {
      do {
        try await useCase.favoriteBookmark(id: bookmarkID)
      } catch {
        state.bookmarkErrorType = .failFavoriteBookmark
      }
    }
  }

  func didTapLeftButton(_ folderID: Int) {
    Task {
      do {
        switch state.viewMode {
        case .owner:
          try await useCase.stopSharingFolder(id: folderID)
          state.viewMode = .ownerNotSharing

        case .subscriber:
          try await useCase.stopSubscription(id: folderID)
          state.viewMode = .subscribeNotSubscribe

        default: return
        }
      } catch {
        switch state.viewMode {
        case .owner:
          state.folderSubscriptionErrorType = .failStopSharing

        case .subscriber:
          state.folderSubscriptionErrorType = .failStopSubscription

        default: return
        }
      }
    }
  }

  func didTapRightButton(_ folderID: Int) {
    Task {
      do {
        switch state.viewMode {
        case .owner, .ownerNotSharing:
          //TODO: 구현 예정
          print("didTapShareButton")

        case .subscribeNotSubscribe:
          try await useCase.subscribeFolder(id: folderID)
          state.viewMode = .subscriber

        default: return
        }
      } catch {
        switch state.viewMode {
        case .ownerNotSharing:
          //TODO: 구현 예정
          print("folderSharingError")

        case .subscribeNotSubscribe:
          state.folderSubscriptionErrorType = .failSubscribe

        default: return
        }
      }
    }
  }
}
