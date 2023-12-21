//
//  FetchBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/09/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

public typealias FetchBookmarkResponse = (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool)

public protocol FetchBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크 리스트를 가져옵니다.
  /// - Returns: bookamrks: 북마크 리스트, currentPage: 현재 페이지, isLastPage: 마지막 페이지 여부
  func fetchBookmarkList(request: BookmarkListRequest, category: BookmarkCategory) async throws -> FetchBookmarkResponse
}

extension FetchBookmarkUseCase {
  func fetchBookmarkList(request: BookmarkListRequest, category: BookmarkCategory) async throws -> FetchBookmarkResponse {
    try await bookmarkRepository.fetchBookmarkList(request: request, category: category)
  }
}
