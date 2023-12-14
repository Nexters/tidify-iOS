//
//  BookmarkListUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

public typealias BookmarkListUseCase = FetchBookmarkUseCase & DeleteBookmarkUseCase & FavoriteBookmarkUseCase

public enum BookmarkListError: Error {
  case failFetchBookmarks
  case failDeleteBookmark
  case failFavoriteBookmark
}

final class DefaultBookmarkListUseCase: BookmarkListUseCase {

  // MARK: Properties
  var bookmarkRepository: BookmarkRepository

  init(repository: BookmarkRepository) {
    self.bookmarkRepository = repository
  }
}
