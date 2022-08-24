//
//  FolderUserCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol FolderUseCase {
  var folderRepository: FolderRepository { get set }

  func fetchFolders() -> [Folder]?
}

public final class DefaultFolderUseCase: FolderUseCase {

  // MARK: - Properties
  public var folderRepository: FolderRepository

  // MARK: - Initializer
  public init(repository: FolderRepository) {
    self.folderRepository = repository
  }

  // MARK: - Methods
  public func fetchFolders() -> [Folder]? {
    return folderRepository.fetchFolders()
  }
}
