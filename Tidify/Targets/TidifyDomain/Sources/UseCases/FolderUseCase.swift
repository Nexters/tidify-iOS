//
//  FolderUserCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderUseCase {
  var folderRepository: FolderRepository { get set }

  func fetchFolders() -> Observable<[Folder]?>
}

public final class DefaultFolderUseCase: FolderUseCase {

  // MARK: - Properties
  public var folderRepository: FolderRepository

  // MARK: - Initializer
  public init(repository: FolderRepository) {
    self.folderRepository = repository
  }

  // MARK: - Methods
  public func fetchFolders() -> Observable<[Folder]?> {
    return folderRepository.fetchFolders().asObservable()
  }
}
