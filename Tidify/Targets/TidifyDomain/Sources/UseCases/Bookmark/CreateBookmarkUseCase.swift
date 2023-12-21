//
//  CreateBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

public enum BookmarkCreationError: Error {
  case failCreateBookmark
  case failUpdateBookmark
}

public protocol CreateBookmarkUseCase {
  var bookmarkRepository: BookmarkRepository { get }

  func createBookmark(request: BookmarkRequestDTO) async throws
}

extension CreateBookmarkUseCase {
  func createBookmark(request: BookmarkRequestDTO) async throws {
    try await bookmarkRepository.createBookmark(request: request)
  }
}

public typealias BookmarkCreationUseCase = CreateBookmarkUseCase & UpdateBookmarkUseCase & FetchFolderUseCase

final class DefaultBookmarkCreationUseCase: BookmarkCreationUseCase {

  // MARK: Properties
  let folderRepository: FolderRepository
  let bookmarkRepository: BookmarkRepository

  // MARK: Initializer
  init(
    bookmarkRepository: BookmarkRepository,
    folderRepository: FolderRepository
  ) {
    self.bookmarkRepository = bookmarkRepository
    self.folderRepository = folderRepository
  }
}
