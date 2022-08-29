//
//  MockHomeRepository.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/08/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

import TidifyDomain

final class MockHomeRepository: HomeRepository {

  func fetchBookmarks(id: Int) -> Single<[Bookmark]> {
    let bookmarks: [Bookmark] = [
      .stub(), .stub(), .stub()
      ]

    return .just(bookmarks)
  }

  func createBookmark(
    url: String,
    title: String?,
    ogImageURL: String?,
    tags: String?
  ) -> Single<Bookmark> {
    return .just(.init(
      id: 0,
      createdAt: "2022-08-26",
      updatedAt: "2022-08-27",
      memberID: 0,
      urlString: url,
      title: title ?? "",
      tag: tags ?? "")
    )
  }
}

