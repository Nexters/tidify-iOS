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

public struct DefaultSearchRepository: SearchRepository {

  // MARK: - Properties
  static let searchHistory: String = "SearchHistory"
  private let bookmarkService: MoyaProvider<BookmarkService>

  // MARK: - Constructor
  public init() {
    self.bookmarkService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchSearchHistory() -> Single<[String]> {
    let searchHistory = UserDefaults.standard.array(forKey: Self.searchHistory) as? [String] ?? []
    return .just(searchHistory.reversed())
  }

  public func fetchSearchResult(query: String) -> Single<[Bookmark]> {
    if !query.isEmpty {
      saveQuery(query: query)
    }

    return bookmarkService.rx.request(.fetchBookmarkList(keyword: query))
      .map(BookmarkListDTO.self)
      .map { $0.toDomain() }
  }

  public func eraseAllSearchHistory() -> Single<Void> {
    UserDefaults.standard.set([], forKey: Self.searchHistory)
    return .just(())
  }
}

private extension DefaultSearchRepository {
  func saveQuery(query: String) {
    var searchHistory = UserDefaults.standard.array(forKey: Self.searchHistory) as? [String] ?? []

    if searchHistory.count > 10 {
      searchHistory.removeFirst()
    }

    searchHistory.append(query)

    UserDefaults.standard.set(searchHistory, forKey: Self.searchHistory)
  }
}