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
  private let coordinator: SearchCoordinator
  private let useCase: SearchUseCase

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
    case searchQuery(_ query: String)
    case requestEraseAllHistory
    case didSelectBookmark(_ bookmark: Bookmark)
  }

  enum Mutation {
    case setSearchHistory(_ searchHistory: [String])
    case setSearchResult(_ bookmarks: [Bookmark])
    case pushWebView(_ bookmark: Bookmark)
  }

  struct State {
    var viewMode: ViewMode
    var searchHistory: [String]
    var searchResult: [Bookmark]
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return useCase.fetchSearchHistory()
        .map { .setSearchHistory($0) }

    case .requestEraseAllHistory:
      return useCase.eraseAllSearchHistory()
        .map { .setSearchHistory([]) }

    case .searchQuery(let query):
      return useCase.fetchSearchResult(query: query)
        .map { .setSearchResult($0)}

    case .didSelectBookmark(let bookmark):
      return .just(.pushWebView(bookmark))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setSearchResult(let bookmarks):
      newState.viewMode = .search
      newState.searchResult = bookmarks

    case .setSearchHistory(let searchHistory):
      newState.viewMode = .history
      newState.searchHistory = searchHistory

    case .pushWebView(let bookmark):
      coordinator.pushWebView(bookmark: bookmark)
    }

    return newState
  }
}
