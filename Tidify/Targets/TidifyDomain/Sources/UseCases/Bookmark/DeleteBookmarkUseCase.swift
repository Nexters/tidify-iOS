//
//  DeleteBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/05/21.
//  Copyright © 2023 Tidify. All rights reserved.
//

import RxSwift

public protocol DeleteBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크를 삭제합니다.
  func deleteBookmark(bookmarkID: Int) -> Observable<Void>
}

extension DeleteBookmarkUseCase {
  func deleteBookmark(bookmarkID: Int) -> Observable<Void> {
    bookmarkRepository.deleteBookmark(bookmarkID: bookmarkID)
      .asObservable()
  }
}
