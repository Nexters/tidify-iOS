//
//  FolderDetailReactor.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/11/17.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class FolderDetailReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init(bookmarks: [])

  private let coordinator: FolderCoordinator
  private let useCase: BookmarkUseCase
  private let folderID: Int

  // MARK: - Initializer
  init(coordinator: FolderCoordinator, useCase: BookmarkUseCase, folderID: Int) {
    self.coordinator = coordinator
    self.useCase = useCase
    self.folderID = folderID
  }

  enum Action {
    case viewWillAppear
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
    case .viewWillAppear:
      // TODO: API 변경에 대한 수정 필요
      //      return useCase.fetchBookmarkList(folderID: folderID)
      //        .map { .setBookmarks($0) }
      return .empty()


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
      coordinator.pushWebView(bookmark: bookmark)
    }

    return newState
  }
}
