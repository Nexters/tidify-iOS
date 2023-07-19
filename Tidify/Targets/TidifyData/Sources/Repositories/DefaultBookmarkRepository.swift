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
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) async throws -> FetchBookmarkListResposne {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.fetchBoomarkList(request: requestDTO), type: BookmarkListResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failFetchBookmarks
    }

    return FetchBookmarkListResposne(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }

  func createBookmark(requestDTO: BookmarkRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.createBookmark(request: requestDTO), type: BookmarkResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failCreateBookmark
    }
  }

  func deleteBookmark(bookmarkID: Int) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.deleteBookmark(ID: bookmarkID), type: APIResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failCreateBookmark
    }
  }

  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: BookmarkEndpoint.updateBookmark(ID: bookmarkID, request: requestDTO), type: APIResponse.self)

    guard response.isSuccess else {
      throw BookmarkError.failUpdateBookmark
    }
  }
}
