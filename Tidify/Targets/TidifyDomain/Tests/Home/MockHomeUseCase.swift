//
//  MockHomeUseCase.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/08/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

import RxSwift
@testable import TidifyDomain

final class MockHomeUseCase: HomeUseCase {
  var repository: HomeRepository = MockHomeRepository()

  func fetchBookmark(id: Int) -> Observable<[Bookmark]> {
    return repository.fetchBookmarks(id: 0)
      .asObservable()
  }

  func createBookmark(
    url: String,
    title: String?,
    ogImageURL: String?,
    tags: String?
  ) -> Observable<Bookmark> {
    return repository.createBookmark(
      url: url,
      title: title,
      ogImageURL: ogImageURL,
      tags: tags
    )
    .asObservable()
  }
}
