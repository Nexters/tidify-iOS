//
//  SearchRepository.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol SearchRepository: AnyObject {

  /// 로컬에 저장되어 있는 검색내역을 반환합니다.
  func fetchSearchHistory() -> [String]

  /// 로컬에 저장되어 있는 검색내역을 초기화합니다.
  func eraseAllSearchHistory()

  /// @GET: 검색 쿼리에 대응되는 결과를 반환합니다.
  func fetchSearchResult(request: BookmarkListRequest) async throws -> FetchBookmarkListResponse
}
