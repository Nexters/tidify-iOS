//
//  FolderDetailUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol FolderDetailUseCase: BookmarkListUseCase {
  var bookmarkRepository: BookmarkRepository { get }

  func fetchBookmarkListInFolder(id: Int, subscribe: Bool) async throws -> FetchBookmarkResponse
  func subscribeFolder(id: Int) async throws
  func stopSubscription(id: Int) async throws
  func stopSharingFolder(id: Int) async throws
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
  func fetchBookmarkListInFolder(id: Int, subscribe: Bool) async throws -> FetchBookmarkResponse {
    try await folderDetailRepository.fetchBookmarkListInFolder(id: id, subscribe: subscribe)
  }

  func subscribeFolder(id: Int) async throws {
    try await folderDetailRepository.subscribeFolder(id: id)
  }

  func stopSubscription(id: Int) async throws {
    try await folderDetailRepository.stopSubscription(id: id)
  }

  func stopSharingFolder(id: Int) async throws {
    try await folderDetailRepository.stopSharingFolder(id: id)
  }
}
