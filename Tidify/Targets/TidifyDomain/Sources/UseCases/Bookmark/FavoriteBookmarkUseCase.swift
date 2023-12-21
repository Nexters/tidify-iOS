//
//  FavoriteBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol FavoriteBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크를 수정합니다.
  func favoriteBookmark(id: Int) async throws
}

extension FavoriteBookmarkUseCase {
  func favoriteBookmark(id: Int) async throws {
    try await bookmarkRepository.favoriteBookmark(bookmarkID: id)
  }
}
