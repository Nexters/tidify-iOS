//
//  HomeRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol BookmarkRepository {

  /// id에 대응되는 북마크 리스트를 반환합니다.
  func fetchBookmarks(id: Int) -> Single<[Bookmark]>

  /// 북마크를 생성합니다.
  func createBookmark(url: String, title: String?, folder: String) -> Single<Bookmark>
}
