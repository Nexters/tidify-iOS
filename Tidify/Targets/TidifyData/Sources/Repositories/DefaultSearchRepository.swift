//
//  DefaultSearchRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyCore
import TidifyDomain

final class DefaultSearchRepository: SearchRepository {

  // MARK: - Properties
  private let networkProvivder: NetworkProviderType
  private let searchHistory: [String] = UserProperties.searchHistory

  // MARK: - Initializer
  public init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvivder = networkProvider
  }

  // MARK: Methods
  func fetchSearchHistory() -> [String] {
    return searchHistory
  }

  func eraseAllSearchHistory() {
    UserProperties.searchHistory = []
  }

  func fetchSearchResult(request: BookmarkListRequest) async throws -> FetchBookmarkListResponse {
    if let keyword = request.keyword {
      saveSearchKeyword(keyword: keyword)
    }

    let response = try await networkProvivder.request(endpoint: BookmarkEndpoint.fetchBoomarkList(request: request), type: BookmarkListResponse.self)

    return FetchBookmarkListResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }
}

private extension DefaultSearchRepository {
  func saveSearchKeyword(keyword: String) {
    var searchHistory = searchHistory

    if let existIndex = searchHistory.firstIndex(of: keyword) {
      searchHistory.remove(at: existIndex)
    }

    if searchHistory.count >= 10 {
      searchHistory.removeFirst()
    }

    searchHistory.append(keyword)

    UserProperties.searchHistory = searchHistory
  }
}
