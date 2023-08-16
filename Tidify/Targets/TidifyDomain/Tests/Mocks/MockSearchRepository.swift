//
//  MockSearchRepository.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/10/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
@testable import TidifyDomain

import RxSwift

final class MockSearchRepository: SearchRepository {

  private(set) var searchHistory: [String] = ["Test1", "Test2", "Test3"]
  private(set) var bookmarks: [Bookmark] = Bookmark.stubList()

  func fetchSearchHistory() -> Single<[String]> {
    return .just(searchHistory)
  }

  func eraseAllSearchHistory() -> Single<Void> {
    searchHistory = []

    return .create { [weak self] observer in
      if self?.searchHistory.isEmpty ?? false {
        observer(.success(()))
      } else {
        observer(.failure(SearchError.failEraseAllSearchHistory))
      }

      return Disposables.create()
    }
  }

  func fetchSearchResult(query: String) -> Single<[Bookmark]> {
    if query.isEmpty {
      return .error(SearchError.emptySearchQuery)
    }

    return .create { [weak self] observer in
      if let searchedBookmarks = self?.bookmarks.filter({ bookmark in bookmark.name.contains(query) }) {
        observer(.success(searchedBookmarks))
      } else {
        observer(.success([]))
      }

      return Disposables.create()
    }
  }

  func fetchSearchResult(requestDTO: BookmarkListRequest) -> Single<FetchBookmarkListResposne> {
    if requestDTO.keyword?.isEmpty ?? true {
      return .error(SearchError.emptySearchQuery)
    }

    return .create { [weak self] observer in
      if let searchedBookmarks = self?.bookmarks.filter({ $0.name.contains(requestDTO.keyword ?? "") }) {
        observer(.success((bookmarks: searchedBookmarks, currentPage: 0, isLastPage: true)))
      } else {
        observer(.success((bookmarks: [], currentPage: 0, isLastPage: true)))
      }

      return Disposables.create()
    }
  }
}
