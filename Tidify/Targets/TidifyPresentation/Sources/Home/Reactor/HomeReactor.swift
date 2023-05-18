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
  var initialState: State = .init(bookmarks: [], didPushWebView: false)

  private weak var coordinator: HomeCoordinator?
  private let useCase: BookmarkUseCase
  private var currentPage: Int = 0
  private var isLastPage: Bool = false
  private(set) var isPaging: Bool = false

  // MARK: - Initializer
  init(coordinator: HomeCoordinator, useCase: BookmarkUseCase) {
    self.coordinator = coordinator
    self.useCase = useCase
  }

  enum Action {
    case fetchBookmarks(isInitialRequest: Bool = false)
    case didSelect(_ bookmark: Bookmark)
    case didDelete(_ bookmark: Bookmark)
    case didFetchSharedBookmark(url: String, title: String)
    case editBookmark(_ index: Int)
  }

  enum Mutation {
    case setBookmarks(_ bookmarks: [Bookmark])
    case pushWebView(_ bookmark: Bookmark)
  }

  struct State {
    var bookmarks: [Bookmark]
    var didPushWebView: Bool
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .fetchBookmarks(let isInitialRequest):
      guard !(isLastPage && !isInitialRequest) else {
        return .empty()
      }
      isPaging = true

      return useCase.fetchBookmarkList(requestDTO: .init(page: isInitialRequest ? 0 : currentPage + 1))
        .flatMapLatest { [weak self] (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool) -> Observable<Mutation> in
          self?.currentPage = currentPage
          self?.isLastPage = isLastPage
          return Observable<Mutation>.just(.setBookmarks(bookmarks.reversed()))
        }

    case .didSelect(let bookmark):
      return .just(.pushWebView(bookmark))

    case .didDelete(let bookmark):
      return useCase.deleteBookmark(bookmarkID: bookmark.id)
        .withLatestFrom(state.map { $0.bookmarks }.asObservable())
        .map { $0.filter { $0.id != bookmark.id } }
        .map { .setBookmarks($0) }

    case let .didFetchSharedBookmark(url, name):
      return useCase.createBookmark(requestDTO: .init(folderID: 0, url: url, name: name))
        .flatMapLatest { [weak self] _ -> Observable<FetchBookmarkListResposne> in
          guard let useCase = self?.useCase else {
            return .empty()
          }

          return useCase.fetchBookmarkList(requestDTO: .init(page: self?.currentPage ?? 0))
        }
        .map { .setBookmarks($0.bookmarks) }

    case .editBookmark(let index):
      coordinator?.pushEditBookmarkScene(bookmark: currentState.bookmarks[index])
      return .empty()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setBookmarks(let newBookmarks):
      var bookmarks = state.bookmarks

      for bookmark in newBookmarks {
        if !bookmarks.contains(bookmark) {
          bookmarks.append(bookmark)
        }
      }

      newState.bookmarks = bookmarks
      isPaging = false

    case .pushWebView(let bookmark):
      newState.didPushWebView = true
      coordinator?.pushWebView(bookmark: bookmark)
    }

    return newState
  }
}
