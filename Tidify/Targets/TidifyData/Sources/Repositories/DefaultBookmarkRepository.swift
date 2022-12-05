//
//  DefaultHomeRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import Moya
import RxSwift

public struct DefaultBookmarkRepository: BookmarkRepository {

  // MARK: - Properties
  private let bookmarkService: MoyaProvider<BookmarkService>

  // MARK: - Initializer
  public init() {
    self.bookmarkService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchBookmarkList(folderID: Int) -> Single<[Bookmark]> {
    return bookmarkService.request(.fetchBookmarkList(folderID: folderID))
      .map(BookmarkListDTO.self)
      .map { $0.toDomain() }
  }

  public func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkService.rx.request(.createBookmark(requestDTO))
      .map { _ in }
  }

  public func deleteBookmark(bookmarkID: Int) -> Single<Void> {
    return bookmarkService.request(.deleteBookmark(bookmarkID: bookmarkID))
      .map { _ in }
  }

  public func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkService.request(.updateBookmark(
      bookmarkID: bookmarkID,
      requestDTO: requestDTO)
    )
    .map { _ in }
  }
}
