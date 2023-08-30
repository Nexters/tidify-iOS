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

  private weak var coordinator: FolderCoordinator?
  private let useCase: FolderDetailUseCase
  private let folderID: Int

  // MARK: - Initializer
  init(coordinator: FolderCoordinator, useCase: FolderDetailUseCase, folderID: Int) {
    self.coordinator = coordinator
    self.useCase = useCase
    self.folderID = folderID
  }

  enum Action {
    case viewWillAppear
    case didSelect(_ bookmark: Bookmark)
    case tryEdit(_ bookmark: Bookmark)
    case tryDelete(_ bookmark: Bookmark)
  }

  enum Mutation {
    case setBookmarks(_ bookmarks: [Bookmark])
    case pushWebView(_ bookmark: Bookmark)
    case pushEditView(_ bookmark: Bookmark)
    case deleteBookmark(_ index: Int)
  }

  struct State {
    var bookmarks: [Bookmark]
  }

  func mutate(action: Action) -> Observable<Mutation> {
//    switch action {
//    case .viewWillAppear:
//      return useCase.fetchBookmarkListInFolder(folderID: folderID)
//        .map { .setBookmarks($0.bookmarks) }
//
//
//    case .didSelect(let bookmark):
//      return .just(.pushWebView(bookmark))
//
//    case .tryEdit(let bookmark):
//      return .just(.pushEditView(bookmark))
//
//    case .tryDelete(let bookmark):
//      return deleteBookmark(bookmark)
//    }
    return .empty()
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setBookmarks(let bookmarks):
      newState.bookmarks = bookmarks

    case .pushWebView(let bookmark):
      coordinator?.pushWebView(bookmark: bookmark)

    case .pushEditView(let bookmark):
      coordinator?.pushBookmarkEditScene(bookmark: bookmark)

    case .deleteBookmark(let index):
      newState.bookmarks.remove(at: index)
    }

    return newState
  }
}

// MARK: - Private
private extension FolderDetailReactor {

  // MARK: Methods
//  func deleteBookmark(_ bookmark: Bookmark) -> Observable<Mutation> {
//    guard let index = currentState.bookmarks.firstIndex(where: { $0.id == bookmark.id }) else {
//      return .empty()
//    }
//
//    return useCase.deleteBookmark(bookmarkID: bookmark.id)
//      .map { .deleteBookmark(index) }
//  }
}
