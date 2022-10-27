//
//  MockHomeRepository.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/08/27.
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

  func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Bookmark> {
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
        observer(.success(bookmark))
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
        updateTargetBookmark.updateBookmark(with: requestDTO)
      }

      let updatedBookmark = self?.bookmarks.first(where: {$0.id == bookmarkID})

      if updatedBookmark?.title == requestDTO.title,
         updatedBookmark?.urlString == requestDTO.url {
        observer(.success(()))
      } else {
        observer(.failure(BookmarkError.failUpdateBookmark))
      }

      return Disposables.create()
    }
  }
}

