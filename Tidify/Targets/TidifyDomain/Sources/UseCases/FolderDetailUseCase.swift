//
//  FolderDetailUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderDetailUseCase {
  func fetchBookmarkListInFolder(folderID: Int) -> Observable<FetchBookmarkListResposne>
}

final class DefaultFolderDetailUseCase: FolderDetailUseCase {

  // MARK: - Properties
  private let folderDetailRepository: FolderDetailRepository

  // MARK: - Initializer
  init(repository: FolderDetailRepository) {
    self.folderDetailRepository = repository
  }

  // MARK: - Methods
  func fetchBookmarkListInFolder(folderID: Int) -> Observable<FetchBookmarkListResposne> {
    folderDetailRepository.fetchBookmarkListInFolder(folderID: folderID).asObservable()
  }
}
