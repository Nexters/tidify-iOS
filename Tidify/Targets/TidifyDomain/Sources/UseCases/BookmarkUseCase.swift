//
//  BookmarkCreationUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/31.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol BookmarkUseCase {
  var repository: BookmarkRepository { get }

  /// id에 대응되는 북마크 리스트를 반환합니다.
  func fetchBookmarks(id: Int) -> Observable<[Bookmark]>

  /// 북마크를 생성합니다.
  func createBookmark(url: String, title: String?, folder: String) -> Observable<Bookmark>
}

final class DefaultBookmarkUseCase: BookmarkUseCase {

  // MARK: - Properties
  let repository: BookmarkRepository

  // MARK: - Constructor
  init(repository: BookmarkRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  func fetchBookmarks(id: Int) -> Observable<[Bookmark]> {
    return repository.fetchBookmarks(id: id)
      .asObservable()
  }

  func createBookmark(url: String, title: String?, folder: String) -> Observable<Bookmark> {
    return repository.createBookmark(url: url, title: title, folder: folder)
      .asObservable()
  }
}

