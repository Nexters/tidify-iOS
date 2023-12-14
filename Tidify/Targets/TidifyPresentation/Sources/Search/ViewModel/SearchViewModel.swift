//
//  SearchViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyCore
import TidifyDomain

final class SearchViewModel: ViewModelType {
  typealias UseCase = SearchListUseCase

  enum Action: Equatable {
    case searchQuery(_ query: String)
    case saveHistory(_ query: String)
    case didTapStarButton(_ bookmarkID: Int)
    case didScroll(_ query: String)
  }

  struct State: Equatable {
    var searchResult: [Bookmark]
  }

  let useCase: UseCase
  @Published var state: State
  private var currentPage: Int = 0
  private var isLastPage: Bool = false

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(searchResult: [])
  }

  func action(_ action: Action) {
    switch action {
    case .searchQuery(let query):
      fetchSearchResult(by: query)
    case .saveHistory(let query):
      saveHistory(query)
    case .didTapStarButton(let bookmarkID):
      didTapStarButton(bookmarkID)
    case .didScroll(let query):
      scrollTableView(query)
    }
  }
}

private extension SearchViewModel {
  func fetchSearchResult(by query: String) {
    guard !query.isEmpty else {
      state.searchResult = []
      return
    }

    currentPage = 0
    Task {
      let fetchSearchResponse = try await useCase.fetchSearchResult(
        request: .init(page: 0, size: 13, keyword: query)
      )
      isLastPage = fetchSearchResponse.isLastPage
      state.searchResult = fetchSearchResponse.bookmarks
      currentPage = 1
    }
  }

  func saveHistory(_ query: String) {
    var searchHistory = UserProperties.searchHistory

    if let existIndex = searchHistory.firstIndex(of: query) {
      searchHistory.remove(at: existIndex)
    }

    if searchHistory.count >= 10 {
      searchHistory.removeFirst()
    }

    searchHistory.append(query)
    UserProperties.searchHistory = searchHistory
  }

  func didTapStarButton(_ bookmarkID: Int) {
    Task {
      try await useCase.favoriteBookmark(id: bookmarkID)
    }
  }

  func scrollTableView(_ query: String) {
    guard !isLastPage else {
      return
    }

    Task {
      let fetchSearchResponse = try await useCase.fetchSearchResult(
        request: .init(page: currentPage, size: 13, keyword: query)
      )
      isLastPage = fetchSearchResponse.isLastPage
      state.searchResult += fetchSearchResponse.bookmarks
      currentPage += 1
    }
  }
}
