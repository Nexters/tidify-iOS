//
//  SearchUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

public enum SearchError: Error {
  case failEraseAllSearchHistory
  case emptySearchQuery
}

public protocol SearchUseCase {
  var searchRepository: SearchRepository { get }

  /// 최근 검색내역을 반환합니다.
  func fetchSearchHistory() -> [String]

  /// 검색 쿼리에 대응되는 결과를 반환합니다.
  func fetchSearchResult(request: BookmarkListRequest) async throws -> FetchBookmarkResponse

  /// 검색내역을 초기화합니다.
  func eraseAllSearchHistory()
}

extension SearchUseCase {
  func fetchSearchHistory() -> [String] {
    searchRepository.fetchSearchHistory()
  }

  func fetchSearchResult(request: BookmarkListRequest) async throws -> FetchBookmarkResponse {
    try await searchRepository.fetchSearchResult(request: request)
  }

  func eraseAllSearchHistory() {
    searchRepository.eraseAllSearchHistory()
  }
}

public typealias SearchListUseCase = SearchUseCase & FetchBookmarkUseCase & FavoriteBookmarkUseCase

final class DefaultSearchListUseCase: SearchListUseCase {

  // MARK: Properties
  let searchRepository: SearchRepository
  let bookmarkRepository: BookmarkRepository

  // MARK: Initializer
  public init(searchRepository: SearchRepository, bookmarkRepository: BookmarkRepository) {
    self.searchRepository = searchRepository
    self.bookmarkRepository = bookmarkRepository
  }
}
