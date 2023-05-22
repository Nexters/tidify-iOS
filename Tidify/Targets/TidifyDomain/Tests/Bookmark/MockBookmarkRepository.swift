//
//  MockBookmarkRepository.swift
//  Tidify
//
//  Created by Ian on 2022/10/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import RxSwift

final class MockBookmarkRepository: BookmarkRepository {
  private(set) var bookmarks: [Bookmark] = [.stub(), .stub(), .stub()]

  func fetchBookmarkList() -> Single<[Bookmark]> {
    return .just(bookmarks)
  }

  func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void> {
    let bookmark: Bookmark = .init(
      id: 0,
      createdAt: Date().toString(),
      updatedAt: Date().toString(),
      folderID: requestDTO.folderID,
      urlString: requestDTO.url,
      title: requestDTO.title
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
    if let bookmark = bookmarks.first(where: { $0.id == bookmarkID }) {
      bookmarks.removeAll(where: { $0.id == bookmark.id })
    }

    return .create { [weak self] observer in
      if self?.bookmarks.contains(where: { $0.id == bookmarkID}) ?? true {
        observer(.failure(BookmarkError.failDeleteBookmark))
      } else {
        observer(.success(()))
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
