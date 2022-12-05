//
//  BookmarkCreationUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/31.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public enum BookmarkError: Error {
  case cannotFindMachedBookmark
  case failFetchBookmarks
  case failCreateBookmark
  case failDeleteBookmark
  case failUpdateBookmark
}

public protocol BookmarkUseCase {
  var repository: BookmarkRepository { get }

  /// id에 대응되는 북마크 리스트를 반환합니다.
  func fetchBookmarkList() -> Observable<[Bookmark]>

  /// 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void>

  /// 북마크를 삭제합니다.
  func deleteBookmark(bookmarkID: Int) -> Observable<Void>

  /// 북마크 정보를 갱신합니다.
  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Observable<Void>
}

final class DefaultBookmarkUseCase: BookmarkUseCase {

  // MARK: - Properties
  let repository: BookmarkRepository

  // MARK: - Initializer
  init(repository: BookmarkRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  func fetchBookmarkList() -> Observable<[Bookmark]> {
    repository.fetchBookmarkList()
      .asObservable()
  }

  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    repository.createBookmark(requestDTO: requestDTO)
      .asObservable()
  }

  func deleteBookmark(bookmarkID: Int) -> Observable<Void> {
    repository.deleteBookmark(bookmarkID: bookmarkID)
      .asObservable()
  }

  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    repository.updateBookmark(bookmarkID: bookmarkID, requestDTO: requestDTO)
      .asObservable()
  }
}

