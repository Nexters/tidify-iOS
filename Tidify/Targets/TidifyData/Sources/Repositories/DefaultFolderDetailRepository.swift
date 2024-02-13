//
//  DefaultFolderDetailRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain

final class DefaultFolderDetailRepository: FolderDetailRepository {

  // MARK: - Properties
  private let networkProvider: NetworkProviderType

  // MARK: - Initializer
  init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvider = networkProvider
  }

  // MARK: - Methods
  func fetchBookmarkListInFolder(id: Int, subscribe: Bool) async throws -> FetchBookmarkResponse {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.fetchBookmarkListInFolder(id: id, subscribe: subscribe), type: BookmarkListResponse.self)

    return FetchBookmarkResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }

  func subscribeFolder(id: Int) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.subscribeFolder(id: id), type: APIResponse.self)
  }

  func stopSubscription(id: Int) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.stopSubscription(id: id), type: APIResponse.self)
  }

  func stopSharingFolder(id: Int) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.stopSharingFolder(id: id), type: APIResponse.self)
  }
}
