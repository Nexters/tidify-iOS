//
//  HomeViewModel.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/09/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class HomeViewModel: ViewModelType {
  typealias UseCase = BookmarkListUseCase

  enum Action: Equatable {
    case initialize
    case didTapCategory(BookmarkCategory)
    case didTapDelete(_ bookmarkID: Int)
    case didTapStarButton(_ bookmarkID: Int)
    case didScroll
    case fetchSharedExtensionsBookmark(url: String, name: String)
  }

  struct State: Equatable {
    var isLoading: Bool
    var category: BookmarkCategory
    var bookmarks: [Bookmark]
    var errorType: BookmarkListError?
  }

  let useCase: UseCase
  @Published var state: State
  private var currentPage: Int = 0
  private var isLastPage: Bool = false

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isLoading: false, category: .normal, bookmarks: [], errorType: nil)
  }

  func action(_ action: Action) {
    switch action {
    case .initialize:
      setupInitailBookmarks()
    case .didTapCategory(let category):
      state.category = category
      setupInitailBookmarks()
    case .didTapDelete(let bookmarkID):
      deleteBookmark(bookmarkID)
    case .didTapStarButton(let bookmarkID):
      didTapStarButton(bookmarkID)
    case .didScroll:
      scrollTableView()
    case let .fetchSharedExtensionsBookmark(url, name):
      createBookmark(url: url, name: name)
    }
  }
}

private extension HomeViewModel {
  func setupInitailBookmarks() {
    Task {
      do {
        state.isLoading = true
        let fetchBookmarkListResponse = try await useCase.fetchBookmarkList(
          request: .init(page: 0),
          category: state.category
        )
        isLastPage = fetchBookmarkListResponse.isLastPage
        state.bookmarks = fetchBookmarkListResponse.bookmarks
        currentPage = 1
        state.isLoading = false
      } catch {
        state.errorType = .failFetchBookmarks
      }
    }
  }

  func createBookmark(url: String, name: String) {
    Task {
      do {
        state.isLoading = true
        try await useCase.createBookmark(request: .init(folderID: 0, url: url, name: name))
        setupInitailBookmarks()
        state.isLoading = false
      } catch {
        state.errorType = .failCreateBookmark
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
        state.isLoading = true
        try await useCase.deleteBookmark(bookmarkID: bookmarkID)
        state.bookmarks.remove(at: index)
        try await addRemovedBookmark()
        state.isLoading = false
      } catch {
        state.errorType = .failDeleteBookmark
      }
    }
  }

  func didTapStarButton(_ bookmarkID: Int) {
    guard let index = state.bookmarks.firstIndex(where: { $0.id == bookmarkID }) else {
      return
    }

    Task {
      do {
        try await useCase.favoriteBookmark(id: bookmarkID)

        guard state.category == .favorite else {
          return
        }

        state.bookmarks.remove(at: index)
        state.isLoading = true
        try await addRemovedBookmark()
        state.isLoading = false
      } catch {
        state.errorType = .failFavoriteBookmark
      }
    }
  }

  func addRemovedBookmark() async throws {
    if isLastPage {
      return
    }

    let fetchBookmarkListResponse = try await useCase.fetchBookmarkList(
      request: .init(page: currentPage-1, size: 12),
      category: state.category
    )
    isLastPage = fetchBookmarkListResponse.isLastPage

    guard let newBookmark = fetchBookmarkListResponse.bookmarks.last else {
      return
    }

    appendBookmarks(bookmarks: [newBookmark], addPage: false)
  }

  func scrollTableView() {
    guard !isLastPage else {
      return
    }

    Task {
      do {
        state.isLoading = true

        let fetchBookmarkListResponse = try await useCase.fetchBookmarkList(
          request: .init(page: currentPage, size: 12),
          category: state.category
        )
        isLastPage = fetchBookmarkListResponse.isLastPage

        appendBookmarks(bookmarks: fetchBookmarkListResponse.bookmarks, addPage: true)
        state.isLoading = false
      } catch {
        state.errorType = .failFetchBookmarks
      }
    }
  }

  func appendBookmarks(bookmarks: [Bookmark], addPage: Bool) {
    if addPage {
      currentPage += 1
    }
    state.bookmarks += bookmarks
  }
}
