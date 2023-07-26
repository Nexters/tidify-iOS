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
  init(networkProvider: NetworkProviderType) {
    self.networkProvider = networkProvider
  }

  // MARK: Methods
  func fetchBookmarkList(request: BookmarkListRequestDTO) async throws -> FetchBookmarkListResponse {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.fetchBoomarkList(request: request), type: BookmarkListResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failFetchBookmarks
    }

    return FetchBookmarkListResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }

  func createBookmark(request: BookmarkRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.createBookmark(request: request), type: BookmarkResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failCreateBookmark
    }
  }

  func deleteBookmark(bookmarkID: Int) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.deleteBookmark(ID: bookmarkID), type: APIResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failDeleteBookmark
    }
  }

  func updateBookmark(bookmarkID: Int, request: BookmarkRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.updateBookmark(ID: bookmarkID, request: request), type: APIResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failUpdateBookmark
    }
  }
}
