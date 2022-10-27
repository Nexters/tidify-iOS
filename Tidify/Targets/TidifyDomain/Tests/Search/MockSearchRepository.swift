//
//  MockSearchRepository.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/10/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import RxSwift

final class MockSearchRepository: SearchRepository {

  private(set) var searchHistory: [String] = ["Test1", "Test2", "Test3"]
  private let bookmarks: [Bookmark] = [.stub(), .stub(), .stub()]

  func fetchSearchHistory() -> Single<[String]> {
    return .just(searchHistory)
  }

  func eraseAllSearchHistory() -> Single<Void> {
    searchHistory = []

    return .create { [weak self] observer in
      if self?.searchHistory.isEmpty ?? false {
        observer(.success(()))
      }

      return Disposables.create()
    }
  }

  func fetchSearchResult(query: String) -> Single<[Bookmark]> {
    return .create { [weak self] observer in
      if self?.bookmarks.map({ $0.title }).contains(query) ?? false,
         let bookmark = self?.bookmarks.first(where: { $0.title == query }) {
        observer(.success([bookmark]))
      } else {
        observer(.success([]))
      }

      return Disposables.create()
    }
  }
}
