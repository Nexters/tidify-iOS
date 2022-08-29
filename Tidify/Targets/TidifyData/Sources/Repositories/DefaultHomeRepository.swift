//
//  DefaultHomeRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import Moya
import RxSwift

public struct DefaultHomeRepository: HomeRepository {

  // MARK: - Properties
  private let servicce: MoyaProvider<BookmarkService>

  // MARK: - Initializer
  public init() {
    self.servicce = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchBookmarks(id: Int) -> Single<[Bookmark]> {
    return servicce.rx.request(.fetchBookmarkList(id: id))
      .map(BookmarkListDTO.self)
      .map { $0.bookmarks.map { $0.toDomain() } }
  }

  public func createBookmark(
    url: String,
    title: String?,
    ogImageURL: String?,
    tags: String?
  ) -> Single<Bookmark> {
    return servicce.rx.request(
      .createBookmark(url: url, title: title, ogImageURL: ogImageURL, tags: tags)
    )
    .map(BookmarkDTO.self)
    .map { $0.toDomain() }
  }
}
