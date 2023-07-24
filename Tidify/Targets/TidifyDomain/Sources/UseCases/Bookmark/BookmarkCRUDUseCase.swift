//
//  BookmarkCRUDUseCase.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/05/25.
//  Copyright © 2023 Tidify. All rights reserved.
//

public enum BookmarkError: Error {
  case cannotFindMachedBookmark
  case failFetchBookmarks
  case failCreateBookmark
  case failDeleteBookmark
  case failUpdateBookmark
}

public typealias BookmarkCRUDUseCase = CreateBookmarkUseCase & FetchBookmarkListUseCase & UpdateBookmarkUseCase & DeleteBookmarkUseCase

final class DefaultBookmarkCRUDUseCase: BookmarkCRUDUseCase {

  // MARK: Properties
  var bookmarkRepository: BookmarkRepository
  var folderRepository: FolderRepository

  // MARK: Initializer
  init(bookmarkRepository: BookmarkRepository, folderRepository: FolderRepository) {
    self.bookmarkRepository = bookmarkRepository
    self.folderRepository = folderRepository
  }
}
