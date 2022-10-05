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
  private let coordiantor: SearchCoordinator

  enum ViewMode {
    case history
    case search
  }

  // MARK: - Constructor
  init(coordinator: SearchCoordinator) {
    self.coordiantor = coordinator
  }

  var initialState: State = .init(viewMode: .history, searchHistory: [], searchResult: [])
}

// MARK: - Reactor
extension SearchReactor: Reactor {
  enum Action {
    case typingQuery(_ query: String)
    case requestEraseAllHistory
  }

  enum Mutation {
    case setSearchHistory
    case setSearchResult
  }

  struct State {
    var viewMode: ViewMode
    var searchHistory: [String]
    var searchResult: [Bookmark]
  }

  func mutate(action: Action) -> Observable<Mutation> {
    return .just(.setSearchHistory)
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    return newState
  }
}
