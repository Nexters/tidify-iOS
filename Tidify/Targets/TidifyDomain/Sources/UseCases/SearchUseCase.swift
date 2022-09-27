//
//  SearchUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

import RxSwift

public protocol SearchUseCase {
  var searchRepository: SearchRepository { get }

  func fetchSearchHistory() -> Observable<[String]>
  func fetchSearchResult(query: String) -> Observable<[Bookmark]>
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
}
