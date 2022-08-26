//
//  HomeUseCase.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol HomeUseCase {
  var repository: HomeRepository { get }

  func fetchBookmark(id: Int) -> Observable<[Bookmark]>
  func createBookmark(url: String, title: String?, ogImageURL: String?, tags: String?) -> Single<Void>
}

public final class DefaultHomeUseCase: HomeUseCase {

  // MARK: - Properties
  public var repository: HomeRepository

  // MARK: - Initialize
  public init(repository: HomeRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  public func fetchBookmark(id: Int) -> Observable<[Bookmark]> {
    return repository.fetchBookmarks(id: id)
      .asObservable()
  }

  public func createBookmark(
    url: String,
    title: String?,
    ogImageURL: String?,
    tags: String?
  ) -> Single<Void> {
    return repository.createBookmark(url: url, title: title, ogImageURL: ogImageURL, tags: tags)
  }
}
