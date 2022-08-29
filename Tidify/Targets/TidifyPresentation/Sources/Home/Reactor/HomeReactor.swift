//
//  HomeReactor.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class HomeReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init(bookmarks: [])

  weak var coordinator: HomeCoordinator?
  private let useCase: HomeUseCase

  // MARK: - Initializer
  init(useCase: HomeUseCase) {
    self.useCase = useCase
  }

  enum Action {
    case viewWillAppear(id: Int)
    case didSelect(_ bookmark: Bookmark)
  }


  enum Mutation {
    case setBookmarks(_ bookmarks: [Bookmark])
    case pushWebView(_ bookmark: Bookmark)
  }

  struct State {
    var bookmarks: [Bookmark]
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear(let id):
      return useCase.fetchBookmark(id: id)
        .map { .setBookmarks($0) }

    case .didSelect(let bookmark):
      return .just(.pushWebView(bookmark))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setBookmarks(let bookmarks):
      newState.bookmarks = bookmarks
    case .pushWebView(let bookmark):
      coordinator?.pushWebView(bookmark: bookmark)
    }

    return newState
  }
}
