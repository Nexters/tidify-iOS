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

final class DefaultBookmarkRepository: BookmarkRepository {

  // MARK: - Properties
  private let bookmarkService: MoyaProvider<BookmarkService>

  // MARK: - Initializer
  public init() {
    self.bookmarkService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Single<FetchBookmarkListResposne> {
    return bookmarkService.rx.request(.fetchBookmarkList(requestDTO: requestDTO))
      .map(BookmarkListResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            let fetchResponse: FetchBookmarkListResposne = (bookmarks: response.bookmarkListDTO.toDomain(), currentPage: response.bookmarkListDTO.currentPage, isLastPage: response.bookmarkListDTO.isLastPage)
            observer(.success(fetchResponse))
          } else {
            observer(.failure(BookmarkError.failFetchBookmarks))
          }

          return Disposables.create()
        }
      }
  }

  public func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkService.rx.request(.createBookmark(requestDTO: requestDTO))
      .map(BookmarkResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            observer(.success(()))
          } else {
            observer(.failure(BookmarkError.failCreateBookmark))
          }

          return Disposables.create()
        }
      }
  }

  public func deleteBookmark(bookmarkID: Int) -> Single<Void> {
    return bookmarkService.rx.request(.deleteBookmark(bookmarkID: bookmarkID))
      .map(APIResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            observer(.success(()))
          } else {
            observer(.failure(BookmarkError.failDeleteBookmark))
          }

          return Disposables.create()
        }
      }
  }

  public func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkService.rx.request(.updateBookmark(bookmarkID: bookmarkID, requestDTO: requestDTO))
      .map(APIResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            observer(.success(()))
          } else {
            observer(.failure(BookmarkError.failUpdateBookmark))
          }

          return Disposables.create()
        }
      }
  }
}
