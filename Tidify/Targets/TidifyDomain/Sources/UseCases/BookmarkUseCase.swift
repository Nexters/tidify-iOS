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

public typealias FetchBookmarkListResposne = (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool)

public protocol BookmarkUseCase: DeleteBookmarkUseCase {
  /// 북마크 리스트를 반환합니다.
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne>

  /// 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void>
}

final class DefaultBookmarkUseCase: BookmarkUseCase {

  // MARK: - Properties
  private let bookmarkRepository: BookmarkRepository

  // MARK: - Initializer
  init(repository: BookmarkRepository) {
    self.bookmarkRepository = repository
  }

  // MARK: - Methods
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne> {
    bookmarkRepository.fetchBookmarkList(requestDTO: requestDTO)
      .asObservable()
  }
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    bookmarkRepository.createBookmark(requestDTO: requestDTO)
      .asObservable()
  }

  func deleteBookmark(bookmarkID: Int) -> Observable<Void> {
    bookmarkRepository.deleteBookmark(bookmarkID: bookmarkID)
      .asObservable()
  }
}
