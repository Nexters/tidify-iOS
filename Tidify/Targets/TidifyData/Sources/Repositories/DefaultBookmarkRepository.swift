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
  public func fetchBookmarkList() -> Single<[Bookmark]> {
    return bookmarkService.request(.fetchBookmarkList())
      .filterSuccessfulStatusCodes()
      .map(BookmarkListDTO.self)
      .flatMap { listDTO in
        return .create { observer in
          if listDTO.response.isSuccess {
            observer(.success(listDTO.toDomain()))
          } else {
            observer(.failure(BookmarkError.failFetchBookmarks))
          }

          return Disposables.create()
        }
      }
  }

  public func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return bookmarkService.request(.createBookmark(requestDTO))
      .filterSuccessfulStatusCodes()
      .map(APIResponse.self)
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
    return bookmarkService.request(.deleteBookmark(bookmarkID: bookmarkID))
      .filterSuccessfulStatusCodes()
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
    return bookmarkService.request(.updateBookmark(bookmarkID: bookmarkID, requestDTO: requestDTO))
      .filterSuccessfulStatusCodes()
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
