//
//  BookmarkRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol BookmarkRepository: AnyObject {

  /// @GET: 대응되는 북마크 리스트를 반환합니다.
  func fetchBookmarkList(request: BookmarkListRequestDTO) async throws -> FetchBookmarkListResponse

  /// @POST: 북마크를 생성합니다.
  func createBookmark(request: BookmarkRequestDTO) async throws

  /// @DELETE: 북마크를 삭제합니다.
  func deleteBookmark(bookmarkID: Int) async throws

  /// @PUT: 북마크 정보를 갱신합니다.
  func updateBookmark(bookmarkID: Int, request: BookmarkRequestDTO) async throws
}
