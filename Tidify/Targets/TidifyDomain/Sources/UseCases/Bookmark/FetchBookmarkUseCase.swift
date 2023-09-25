//
//  FetchBookmarkUseCase.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/09/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

final class DefaultFetchBookmarkUseCase: FetchBookmarkListUseCase {

  // MARK: Properties
  var bookmarkRepository: BookmarkRepository

  init(bookmarkRepository: BookmarkRepository) {
    self.bookmarkRepository = bookmarkRepository
  }
}
