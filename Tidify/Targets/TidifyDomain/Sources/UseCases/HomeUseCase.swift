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
  func createBookmark(url: String, title: String?, ogImageURL: String?, tags: String?) -> Observable<Bookmark>
}

final class DefaultHomeUseCase: HomeUseCase {

  // MARK: - Properties
  let repository: HomeRepository

  // MARK: - Initialize
  init(repository: HomeRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  func fetchBookmark(id: Int) -> Observable<[Bookmark]> {
    return repository.fetchBookmarks(id: id)
      .asObservable()
  }

  func createBookmark(
    url: String,
    title: String?,
    ogImageURL: String?,
    tags: String?
  ) -> Observable<Bookmark> {
    return repository.createBookmark(url: url, title: title, ogImageURL: ogImageURL, tags: tags)
      .asObservable()
  }
}
