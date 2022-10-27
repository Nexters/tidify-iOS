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
}

public protocol SearchUseCase {
  var searchRepository: SearchRepository { get }

  /// 최근 검색내역을 반환합니다.
  func fetchSearchHistory() -> Observable<[String]>

  /// 검색 쿼리에 대응되는 결과를 반환합니다.
  func fetchSearchResult(query: String) -> Observable<[Bookmark]>

  /// 검색내역을 초기화합니다.
  func eraseAllSearchHistory() -> Observable<Void>
}

public final class DefaultSearchUseCase: SearchUseCase {

  // MARK: - Properties
  public var searchRepository: SearchRepository

  public init(searchRepository: SearchRepository) {
    self.searchRepository = searchRepository
  }

  public func fetchSearchHistory() -> Observable<[String]> {
    searchRepository.fetchSearchHistory()
      .asObservable()
  }

  public func fetchSearchResult(query: String) -> Observable<[Bookmark]> {
    searchRepository.fetchSearchResult(query: query)
      .asObservable()
  }

  public func eraseAllSearchHistory() -> Observable<Void> {
    searchRepository.eraseAllSearchHistory()
      .asObservable()
  }
}
