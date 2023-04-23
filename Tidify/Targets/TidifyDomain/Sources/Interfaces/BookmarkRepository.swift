//
//  HomeRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol BookmarkRepository: AnyObject {

  /// @GET: 대응되는 북마크 리스트를 반환합니다.
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Single<FetchBookmarkListResposne>

  /// @POST: 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Single<Void>

  /// @DELETE: 북마크를 삭제합니다.
  func deleteBookmark(bookmarkID: Int) -> Single<Void>

  /// @PUT: 북마크 정보를 갱신합니다.
  func updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO) -> Single<Void>
}
