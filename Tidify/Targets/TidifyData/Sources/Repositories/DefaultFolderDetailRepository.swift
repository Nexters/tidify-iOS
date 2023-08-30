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
  func fetchBookmarkListInFolder(id: Int) async throws -> FetchBookmarkListResponse {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.fetchBookmarkListInFolder(id: id), type: BookmarkListResponse.self)

    return FetchBookmarkListResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }
}
