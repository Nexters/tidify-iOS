//
//  CreateBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol CreateBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }
  var folderRepository: FolderRepository { get }

  /// 북마크를 생성합니다.
  func createBookmark(request: BookmarkRequestDTO) async throws

  /// 본인 소유의 폴더를 가져옵니다.
  func fetchFolders() async throws -> [Folder]
}

extension CreateBookmarkUseCase {
  func createBookmark(request: BookmarkRequestDTO) async throws {
    try await bookmarkRepository.createBookmark(request: request)
  }

  func fetchFolders() async throws -> [Folder] {
    return []
  }
}

final class DefaultCreateBookmarkUseCase: CreateBookmarkUseCase, UpdateBookmarkUseCase {

  // MARK: - Properties
  let bookmarkRepository: BookmarkRepository
  let folderRepository: FolderRepository

  init(
    bookmarkRepository: BookmarkRepository,
    folderRepository: FolderRepository
  ) {
    self.bookmarkRepository = bookmarkRepository
    self.folderRepository = folderRepository
  }
}
