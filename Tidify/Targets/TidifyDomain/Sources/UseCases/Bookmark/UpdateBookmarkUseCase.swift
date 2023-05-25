//
//  UpdateBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/05/04.
//  Copyright © 2023 Tidify. All rights reserved.
//

import RxSwift

public protocol UpdateBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }

  /// 북마크를 수정합니다.
  func updateBookmark(id: Int, requestDTO: BookmarkRequestDTO) -> Observable<Void>
}

extension UpdateBookmarkUseCase {
  func updateBookmark(id: Int, requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    bookmarkRepository.updateBookmark(bookmarkID: id, requestDTO: requestDTO)
      .asObservable()
  }
}
