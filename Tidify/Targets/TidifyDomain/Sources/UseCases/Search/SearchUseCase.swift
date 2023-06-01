//
//  SearchUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

import RxSwift

public enum SearchError: Error {
  case failEraseAllSearchHistory
  case emptySearchQuery
}

public protocol SearchUseCase {
  /// 최근 검색내역을 반환합니다.
  func fetchSearchHistory() -> Observable<[String]>

  /// 검색 쿼리에 대응되는 결과를 반환합니다.
  func fetchSearchResult(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne>

  /// 검색내역을 초기화합니다.
  func eraseAllSearchHistory() -> Observable<Void>
}

final class DefaultSearchUseCase: SearchUseCase {

  // MARK: - Properties
  private let searchRepository: SearchRepository

  // MARK: Initializer
  public init(searchRepository: SearchRepository) {
    self.searchRepository = searchRepository
  }

  public func fetchSearchHistory() -> Observable<[String]> {
    searchRepository.fetchSearchHistory()
      .asObservable()
  }

  func fetchSearchResult(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne> {
    searchRepository.fetchSearchResult(requestDTO: requestDTO)
      .asObservable()
  }

  public func eraseAllSearchHistory() -> Observable<Void> {
    searchRepository.eraseAllSearchHistory()
      .asObservable()
  }
}
