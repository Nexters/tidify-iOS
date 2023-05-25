//
//  FetchBookmarkListUseCase.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/05/25.
//  Copyright © 2023 Tidify. All rights reserved.
//

import RxSwift

public typealias FetchBookmarkListResposne = (bookmarks: [Bookmark], currentPage: Int, isLastPage: Bool)

public protocol FetchBookmarkListUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크 리스트를 가져옵니다.
  /// - Returns: bookamrks: 북마크 리스트, currentPage: 현재 페이지, isLastPage: 마지막 페이지 여부
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne>
}

extension FetchBookmarkListUseCase {
  func fetchBookmarkList(requestDTO: BookmarkListRequestDTO) -> Observable<FetchBookmarkListResposne> {
    bookmarkRepository.fetchBookmarkList(requestDTO: requestDTO)
      .asObservable()
  }
}
