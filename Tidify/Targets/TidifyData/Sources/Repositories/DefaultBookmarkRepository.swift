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
  private let bookmarkServicce: MoyaProvider<BookmarkService>

  // MARK: - Initializer
  public init() {
    self.bookmarkServicce = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func fetchBookmarkList() -> Single<[Bookmark]> {
    return bookmarkServicce.rx.request(.fetchBookmarkList())
      .map(BookmarkListDTO.self)
      .map { $0.toDomain() }
  }

  public func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Bookmark> {
    return bookmarkServicce.rx.request(.createBookmark(requestDTO))
      .map(BookmarkDTO.self)
      .map { $0.toDomaion() }
  }

  public func deleteBookmark(bookmarkID: Int) -> Single<Void> {
    return bookmarkServicce.rx.request(.deleteBookmark(bookmarkID: bookmarkID))
      .map { _ in }
  }

  public func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkServicce.rx.request(.updateBookmark(
      bookmarkID: bookmarkID,
      requestDTO: requestDTO)
    )
    .map { _ in }
  }
}