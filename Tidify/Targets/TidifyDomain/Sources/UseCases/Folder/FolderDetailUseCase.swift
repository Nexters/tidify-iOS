//
//  FolderDetailUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol FolderDetailUseCase: DeleteBookmarkUseCase {
  var bookmarkRepository: BookmarkRepository { get }

  func fetchBookmarkListInFolder(id: Int) async throws -> FetchBookmarkListResponse
}

final class DefaultFolderDetailUseCase: FolderDetailUseCase {

  // MARK: - Properties
  private let folderDetailRepository: FolderDetailRepository
  let bookmarkRepository: BookmarkRepository

  // MARK: - Initializer
  init(folderDetailRepository: FolderDetailRepository, bookmarkRepository: BookmarkRepository) {
    self.folderDetailRepository = folderDetailRepository
    self.bookmarkRepository = bookmarkRepository
  }

  // MARK: - Methods
  func fetchBookmarkListInFolder(id: Int) async throws -> FetchBookmarkListResponse {
    try await folderDetailRepository.fetchBookmarkListInFolder(id: id)
  }
}
