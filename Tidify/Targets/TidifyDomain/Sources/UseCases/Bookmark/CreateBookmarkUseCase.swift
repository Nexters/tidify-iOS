//
//  CreateBookmarkUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol CreateBookmarkUseCase: UpdateBookmarkUseCase {

  var bookmarkRepository: BookmarkRepository { get }
  var folderRepository: FolderRepository { get }

  /// 북마크를 생성합니다.
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void>

  /// 본인 소유의 폴더를 가져옵니다.
  func fetchFolders() -> Observable<[Folder]>
}

extension CreateBookmarkUseCase {
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

final class DefaultCreateBookmarkUseCase: CreateBookmarkUseCase {

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
  func createBookmark(requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    bookmarkRepository.createBookmark(requestDTO: requestDTO)
      .asObservable()
  }

  func updateBookmark(id: Int, requestDTO: BookmarkRequestDTO) -> Observable<Void> {
    bookmarkRepository.updateBookmark(bookmarkID: id, requestDTO: requestDTO)
      .asObservable()
  }

  func fetchFolders() -> Observable<[Folder]> {
    folderRepository.fetchFolders(start: 0, count: .max)
      .map { $0.folders }
      .asObservable()
  }
}
