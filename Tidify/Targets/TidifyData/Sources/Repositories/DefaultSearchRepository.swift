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
  static let searchHistory: String = "SearchHistory"
  private let bookmarkService: MoyaProvider<BookmarkService>

  // MARK: - Initializer
  public init() {
    self.bookmarkService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchSearchHistory() -> Single<[String]> {
    let searchHistory = UserDefaults.standard.array(forKey: Self.searchHistory) as? [String] ?? []

    return .create { observer -> Disposable in
      observer(.success(searchHistory.reversed()))

      return Disposables.create()
    }
  }

  func fetchSearchResult(requestDTO: BookmarkListRequestDTO) -> Single<FetchBookmarkListResponse> {
    if let keyword = requestDTO.keyword {
      saveSearchKeyword(keyword: keyword)
    }

    return bookmarkService.rx.request(.fetchBookmarkList(requestDTO: requestDTO))
      .map(BookmarkListResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            let fetchResponse: FetchBookmarkListResponse = (
              bookmarks: response.bookmarkListDTO.toDomain(),
              currentPage: response.bookmarkListDTO.currentPage,
              isLastPage: response.bookmarkListDTO.isLastPage
            )
            observer(.success(fetchResponse))
          } else {
            observer(.failure(BookmarkError.failFetchBookmarks))
          }

          return Disposables.create()
        }
      }
  }

  public func eraseAllSearchHistory() -> Single<Void> {
    UserDefaults.standard.set([], forKey: Self.searchHistory)

    let searchHistory = UserDefaults.standard.array(forKey: Self.searchHistory) as? [String] ?? []

    return .create { observer -> Disposable in
      if searchHistory.isEmpty {
        observer(.success(()))
      } else {
        observer(.failure(SearchError.failEraseAllSearchHistory))
      }

      return Disposables.create()
    }
  }
}

private extension DefaultSearchRepository {
  func saveSearchKeyword(keyword: String) {
    var searchHistory = UserDefaults.standard.array(forKey: Self.searchHistory) as? [String] ?? []

    if let existIndex = searchHistory.firstIndex(of: keyword) {
      searchHistory.remove(at: existIndex)
    }

    if searchHistory.count >= 10 {
      searchHistory.removeFirst()
    }

    searchHistory.append(keyword)

    UserDefaults.standard.set(searchHistory, forKey: Self.searchHistory)
  }
}
