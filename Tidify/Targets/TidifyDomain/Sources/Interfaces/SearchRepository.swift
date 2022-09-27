//
//  SearchRepository.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol SearchRepository {
  func fetchSearchHistory() -> Single<[String]>
  func fetchSearchResult(query: String) -> Single<[Bookmark]>
}
