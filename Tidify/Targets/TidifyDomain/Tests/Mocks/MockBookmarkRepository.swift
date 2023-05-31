//
//  MockBookmarkRepository.swift
//  Tidify
//
//  Created by Ian on 2022/10/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import RxSwift
@testable import TidifyDomain

final class MockBookmarkRepository: BookmarkRepository {

  private(set) var bookmarks: [Bookmark] = Bookmark.stubList()

  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Single<FetchBookmarkListResposne> {
    return .create { [weak self] observer in
      if let keyword = requestDTO.keyword {
        observer(.success((bookmarks: self?.bookmarks.filter { $0.name.contains(keyword)} ?? [] , currentPage: 1, isLastPage: true)))
      } else {
        observer(.success((bookmarks: self?.bookmarks ?? [], currentPage: 1, isLastPage: true)))
      }

      return Disposables.create()
    }
  }

  func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void> {
    let bookmark: Bookmark = .init(
      id: 99,
      folderID: requestDTO.folderID,
      urlString: requestDTO.url,
      name: requestDTO.name
    )
    bookmarks.append(bookmark)

    return .create { [weak self] observer in
      if self?.bookmarks.contains(bookmark) ?? false {
        observer(.success(()))
      } else {
        observer(.failure(BookmarkError.failCreateBookmark))
      }

      return Disposables.create()
    }
  }

  func deleteBookmark(bookmarkID: Int) -> Single<Void> {
    return .create { [weak self] observer in
      if let index = self?.bookmarks.firstIndex(where: { $0.id == bookmarkID }) {
        self?.bookmarks.remove(at: index)
        observer(.success(()))
      } else {
        observer(.failure(BookmarkError.cannotFindMachedBookmark))
      }

      return Disposables.create()
    }
  }

  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void> {
    return .create { [weak self] observer in
      if var updateTargetBookmark = self?.bookmarks.first(where: { $0.id == bookmarkID}) {
        updateTargetBookmark.update(with: requestDTO)

        if updateTargetBookmark.name == requestDTO.name,
           updateTargetBookmark.urlString == requestDTO.url {
          observer(.success(()))
        } else {
          observer(.failure(BookmarkError.failUpdateBookmark))
        }
      }

      return Disposables.create()
    }
  }
}
