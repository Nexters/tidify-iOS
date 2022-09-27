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

    if bookmarks.contains(bookmark) {
      return .just(bookmark)
    } else {
      return .error(BookmarkError.failCreateBookmark)
    }
  }

  func deleteBookmark(bookmarkID: Int) -> Single<Void> {
    if let bookmark = bookmarks.first(where: { $0.id == bookmarkID}) {
      bookmarks.removeAll(where: { $0.id == bookmark.id })

      return .just(())
    } else {
      return .error(BookmarkError.cannotFindMachedBookmark)
    }
  }

  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void> {
    if var updateTargetBookmark = bookmarks.first(where: { $0.id == bookmarkID}) {
      updateTargetBookmark.updateBookmark(with: requestDTO)

      return .just(())
    } else {
      return .error(BookmarkError.cannotFindMachedBookmark)
    }
  }
}

