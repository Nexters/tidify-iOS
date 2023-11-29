//
//  FolderListUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/11/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

public typealias FolderListUseCase = FetchFolderUseCase & DeleteFolderUseCase

public enum FolderListError: Error {
  case failFetchFolderList
  case failDeleteFolder
}

final class DefaultFolderListUseCase: FolderListUseCase {

  // MARK: Properties
  var folderRepository: FolderRepository

  init(repository: FolderRepository) {
    self.folderRepository = repository
  }
}
