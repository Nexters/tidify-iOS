//
//  SearchReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class SearchReactor {

  // MARK: - Properties
  private let coordinator: SearchCoordinator?
  private let useCase: SearchUseCase
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  private var lastKeyword: String = ""
  private var isSearching: Bool = false

  enum ViewMode {
    case history
    case search
  }

  // MARK: - Initializer
  init(coordinator: SearchCoordinator, useCase: SearchUseCase) {
    self.coordinator = coordinator
    self.useCase = useCase
  }

  var initialState: State = .init(viewMode: .history, searchHistory: [], searchResult: [])
}

// MARK: - Reactor
extension SearchReactor: Reactor {
  enum Action {
    case viewWillAppear
    case inputKeyword
    case searchQuery(_ query: String)
    case requestEraseAllHistory
    case didSelectBookmark(_ bookmark: Bookmark)
  }

  enum Mutation {
    case clearSearchResult
    case setSearchHistory(_ searchHistory: [String])
    case setSearchResult(_ bookmarks: [Bookmark], isInitialRequest: Bool)
    case pushWebView(_ bookmark: Bookmark)
  }

  struct State {
    var viewMode: ViewMode
    var searchHistory: [String]
    var searchResult: [Bookmark]
  }

  func mutate(action: Action) -> Observable<Mutation> {
    let fetchSearchHistory: Observable<Mutation> = useCase.fetchSearchHistory()
      .map { .setSearchHistory($0) }

    switch action {
    case .viewWillAppear:
      return fetchSearchHistory

    case .inputKeyword:
      return .just(.clearSearchResult)

    case .requestEraseAllHistory:
      return useCase.eraseAllSearchHistory()
        .map { .setSearchHistory([]) }

    case .searchQuery(let keyword):
      if keyword.isEmpty {
        return fetchSearchHistory
      }
      
      let isInitialRequest = !isSameWithLastKeyword(currentKeyword: keyword)

      guard !isLastPage && !isSearching else {
        return .empty()
      }

      isSearching = true
      return useCase.fetchSearchResult(requestDTO: .init(page: isInitialRequest ? 0 : currentPage + 1, keyword: keyword))
        .flatMapLatest { [weak self] (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool) -> Observable<Mutation> in
          self?.currentPage = currentPage
          self?.isLastPage = isLastPage
          return Observable<Mutation>.just(.setSearchResult(bookmarks, isInitialRequest: isInitialRequest))
        }

    case .didSelectBookmark(let bookmark):
      return .just(.pushWebView(bookmark))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .clearSearchResult:
      newState.searchResult = .init()

    case let .setSearchResult(bookmarks, isInitialRequest):
      newState.viewMode = .search
      var searchResult: [Bookmark] = isInitialRequest ? .init() : newState.searchResult
      searchResult.append(contentsOf: bookmarks)

      isSearching = false
      newState.searchResult = searchResult

    case .setSearchHistory(let searchHistory):
      lastKeyword = ""
      newState.viewMode = .history
      newState.searchHistory = searchHistory

    case .pushWebView(let bookmark):
      coordinator?.pushWebView(bookmark: bookmark)
    }

    return newState
  }
}

// MARK: - Extension
private extension SearchReactor {
  func isSameWithLastKeyword(currentKeyword: String) -> Bool {
    if lastKeyword == currentKeyword {
      return true
    }

    lastKeyword = currentKeyword
    isLastPage = false
    currentPage = 0
    return false
  }
}
