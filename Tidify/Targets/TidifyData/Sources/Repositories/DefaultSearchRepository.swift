//
//  DefaultSearchRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya
import RxSwift

final class DefaultSearchRepository: SearchRepository {

  // MARK: - Properties
  private let networkProvivder: NetworkProviderType

  // MARK: - Initializer
  public init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvivder = networkProvider
  }

  // MARK: Methods
  func fetchSearchHistory() -> [String] {
    // TODO: - PropertyWrapper & LocalStorage 적용
    let history = UserDefaults.standard.array(forKey: "SearchHistory") as? [String]

    return history ?? []
  }

  func eraseAllSearchHistory() {
    UserDefaults.standard.set([], forKey: "SearchHistory")
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
        var searchHistory = UserDefaults.standard.array(forKey: "SearchHistory") as? [String] ?? []

        if let existIndex = searchHistory.firstIndex(of: keyword) {
          searchHistory.remove(at: existIndex)
        }

        if searchHistory.count >= 10 {
          searchHistory.removeFirst()
        }

        searchHistory.append(keyword)

        UserDefaults.standard.set(searchHistory, forKey: "SearchHistory")
  }
}
