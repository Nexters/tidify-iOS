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

  // MARK: - Initializer
  public init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvivder = networkProvider
  }

  // MARK: Methods
  func fetchSearchHistory() -> [String] {
    return UserProperties.searchHistory
  }

  func eraseAllSearchHistory() {
    UserProperties.searchHistory = []
  }

  func fetchSearchResult(request: BookmarkListRequest) async throws -> FetchBookmarkResponse {
    let response = try await networkProvivder.request(
      endpoint: BookmarkEndpoint.fetchBoomarkList(request: request, category: .normal),
      type: BookmarkListResponse.self
    )

    return FetchBookmarkResponse(
      bookmarks: response.toDomain(),
      currentPage: response.bookmarkListDTO.currentPage,
      isLastPage: response.bookmarkListDTO.isLastPage
    )
  }
}
