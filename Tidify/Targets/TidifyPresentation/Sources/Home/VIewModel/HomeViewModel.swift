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

  enum ViewMode {
    case bookmarkList
    case search
  }

  enum Action {
    case viewDidLoad
    case fetchBookmarks
    case search(keyword: String)
  }

  struct State: Equatable {
    var isLoading: Bool
    var bookmarks: [Bookmark]
    var searchHistory: [String]
    var viewMode: ViewMode
  }

  @Published var state: State
  private let fetchUseCase: FetchBookmarkListUseCase
  private let searchUseCase: SearchUseCase
  private var currentPage: Int = 0
  private var isLastPage: Bool = false

  init(fetchUseCase: FetchBookmarkListUseCase, searchUseCase: SearchUseCase) {
    self.fetchUseCase = fetchUseCase
    self.searchUseCase = searchUseCase
    state = .init(isLoading: false, bookmarks: [], searchHistory: [], viewMode: .bookmarkList)
  }

  func action(_ action: Action) {
    switch action {
    case .viewDidLoad:
      self.setInitialState()
    case .fetchBookmarks:
      self.fetchBookmarks()
    case .search(let keyword):
      self.searchBookmark(keyword)
    }
  }
}

private extension HomeViewModel {
  func setInitialState() {
    Task {
      state.isLoading = true
      let bookmarkResponse = try await fetchUseCase.fetchBookmarkList(request: .init(page: 0))
      let searchHistory = searchUseCase.fetchSearchHistory()

      currentPage = bookmarkResponse.currentPage
      isLastPage = bookmarkResponse.isLastPage
      state.bookmarks = bookmarkResponse.bookmarks
      state.isLoading = false
    }
    state.searchHistory = searchUseCase.fetchSearchHistory()
  }

  func fetchBookmarks() {
    guard !isLastPage else {
      state.isLoading = false
      return
    }

    currentPage += 1

    Task {
      state.isLoading = true
      let response = try await fetchUseCase.fetchBookmarkList(request: .init(page: currentPage))
      state.bookmarks = response.bookmarks
      currentPage = response.currentPage
      isLastPage = response.isLastPage
      state.isLoading = false
    }
  }

  func searchBookmark(_ keyword: String) {
    guard !keyword.isEmpty else {
      setInitialState()
      state.viewMode = .bookmarkList
      return
    }

    if state.viewMode != .search {
      state.viewMode = .search
    }

    Task {
      state.isLoading = true
      let searchResponse = try await searchUseCase.fetchSearchResult(request: .init(page: currentPage, keyword: keyword))
      state.bookmarks = searchResponse.bookmarks
      state.isLoading = false
    }
  }
}
