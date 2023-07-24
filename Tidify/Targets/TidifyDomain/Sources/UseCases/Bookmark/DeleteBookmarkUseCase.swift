//
//  DeleteBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/05/21.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol DeleteBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크를 삭제합니다.
  func deleteBookmark(bookmarkID: Int) async throws
}

extension DeleteBookmarkUseCase {
  func deleteBookmark(bookmarkID: Int) async throws {
    try await bookmarkRepository.deleteBookmark(bookmarkID: bookmarkID)
  }
}
