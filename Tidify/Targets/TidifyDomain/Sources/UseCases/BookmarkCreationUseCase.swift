//
//  BookmarkCreationUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol BookmarkCreationUseCase {
  /// 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void>

  /// 본인 소유의 폴더를 가져옵니다.
  func fetchFolders() -> Observable<[Folder]>
}

final class DefaultBookmarkCreationUseCase: BookmarkCreationUseCase {

  // MARK: - Properties
  private let bookmarkRepository: BookmarkRepository
  private let folderRepository: FolderRepository

  init(
    bookmarkRepository: BookmarkRepository,
    folderRepository: FolderRepository
  ) {
    self.bookmarkRepository = bookmarkRepository
    self.folderRepository = folderRepository
  }

  // MARK: - Methods
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    bookmarkRepository.createBookmark(requestDTO: requestDTO)
      .asObservable()
  }

  func fetchFolders() -> Observable<[Folder]> {
    folderRepository.fetchFolders(start: 0, count: .max)
      .map { $0.folders }
      .asObservable()
  }
}
