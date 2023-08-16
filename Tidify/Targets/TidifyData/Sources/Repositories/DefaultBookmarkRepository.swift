//
//  DefaultHomeRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

final class DefaultBookmarkRepository: BookmarkRepository {

  // MARK: Properties
  private let networkProvider: NetworkProviderType

  // MARK: Initializer
  init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvider = networkProvider
  }

  // MARK: Methods
  func fetchBookmarkList(request: BookmarkListRequest) async throws -> FetchBookmarkListResponse {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.fetchBoomarkList(request: request), type: BookmarkListResponse.self)

    return FetchBookmarkListResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }

  func createBookmark(request: BookmarkRequestDTO) async throws {
    try await networkProvider.request(endpoint: BookmarkEndpoint.createBookmark(request: request), type: BookmarkResponse.self)
  }

  func deleteBookmark(bookmarkID: Int) async throws {
    try await networkProvider.request(endpoint: BookmarkEndpoint.deleteBookmark(ID: bookmarkID), type: APIResponse.self)
  }

  func updateBookmark(bookmarkID: Int, request: BookmarkRequestDTO) async throws {
    try await networkProvider.request(endpoint: BookmarkEndpoint.updateBookmark(ID: bookmarkID, request: request), type: APIResponse.self)
  }
}
