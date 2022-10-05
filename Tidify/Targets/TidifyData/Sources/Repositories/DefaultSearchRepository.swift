//
//  DefaultSearchRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import Moya
import RxSwift

public struct DefaultSearchRepository: SearchRepository {

  // MARK: - Properties
  private let bookmarkService: MoyaProvider<BookmarkService>

  // MARK: - Constructor
  public init() {
    self.bookmarkService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchSearchHistory() -> Single<[String]> {
    // TODO: Implementation
    return .just([])
  }

  public func fetchSearchResult(query: String) -> Single<[Bookmark]> {
    // TODO: Implementation
    return .just([])
  }
}
