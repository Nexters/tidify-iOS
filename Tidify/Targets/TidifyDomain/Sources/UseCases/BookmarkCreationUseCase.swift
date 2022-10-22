//
//  BookmarkCreationUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol BookmarkCreationUseCase {
  var bookmarkRepository: BookmarkRepository { get }
  var folderRepository: FolderRepository { get }

  /// 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Bookmark>

  /// 본인 소유의 폴더를 가져옵니다.
  func fetchFolders() -> Observable<[Folder]>
}

final class DefaultBookmarkCreationUseCase: BookmarkCreationUseCase {

  // MARK: - Properties
  let bookmarkRepository: BookmarkRepository
  let folderRepository: FolderRepository

  init(
    bookmarkRepository: BookmarkRepository,
    folderRepository: FolderRepository
  ) {
    self.bookmarkRepository = bookmarkRepository
    self.folderRepository = folderRepository
  }

  // MARK: - Methods
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Bookmark> {
    bookmarkRepository.createBookmark(requestDTO: requestDTO)
      .asObservable()
  }

  func fetchFolders() -> Observable<[Folder]> {
    folderRepository.fetchFolders()
      .asObservable()
  }
}
