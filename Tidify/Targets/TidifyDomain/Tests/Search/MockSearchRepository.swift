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
  private let bookmarks: [Bookmark] = Bookmark.stubList()

  func fetchSearchResult(requestDTO: BookmarkListRequestDTO) -> Single<FetchBookmarkListResposne> {
    return .just((bookmarks: bookmarks, currentPage: 0, isLastPage: true))
  }

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
    return .create { [weak self] observer in
      if self?.bookmarks.map({ $0.name }).contains(query) ?? false,
         let bookmark = self?.bookmarks.first(where: { $0.name == query }) {
        observer(.success([bookmark]))
      } else {
        observer(.success([]))
      }

      return Disposables.create()
    }
  }
}
