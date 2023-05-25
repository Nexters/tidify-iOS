//
//  FolderDetailUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderDetailUseCase: DeleteBookmarkUseCase {
  func fetchBookmarkListInFolder(folderID: Int) -> Observable<FetchBookmarkListResposne>
}

final class DefaultFolderDetailUseCase: FolderDetailUseCase {

  // MARK: - Properties
  private let folderDetailRepository: FolderDetailRepository
  let bookmarkRepository: BookmarkRepository

  // MARK: - Initializer
  init(folderDetailRepository: FolderDetailRepository, bookmarkRepository: BookmarkRepository) {
    self.folderDetailRepository = folderDetailRepository
    self.bookmarkRepository = bookmarkRepository
  }

  // MARK: - Methods
  func fetchBookmarkListInFolder(folderID: Int) -> Observable<FetchBookmarkListResposne> {
    folderDetailRepository.fetchBookmarkListInFolder(folderID: folderID).asObservable()
  }

  func deleteBookmark(bookmarkID: Int) -> Observable<Void> {
    bookmarkRepository.deleteBookmark(bookmarkID: bookmarkID)
      .asObservable()
  }
}
