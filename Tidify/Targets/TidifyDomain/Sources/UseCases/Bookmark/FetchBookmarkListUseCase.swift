//
//  FetchBookmarkListUseCase.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/05/25.
//  Copyright © 2023 Tidify. All rights reserved.
//

public typealias FetchBookmarkListResponse = (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool)

public protocol FetchBookmarkListUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크 리스트를 가져옵니다.
  /// - Returns: bookamrks: 북마크 리스트, currentPage: 현재 페이지, isLastPage: 마지막 페이지 여부
  func fetchBookmarkList(request: BookmarkListRequestDTO) async throws -> FetchBookmarkListResponse
}

extension FetchBookmarkListUseCase {
  func fetchBookmarkList(request: BookmarkListRequestDTO) async throws -> FetchBookmarkListResponse {
    try await bookmarkRepository.fetchBookmarkList(request: request)
  }
}
