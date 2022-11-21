//
//  FolderUserCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderUseCase {
  var repository: FolderRepository { get }

  func createFolder(requestDTO: FolderRequestDTO) -> Observable<Void>
  func fetchFolders(start: Int, count: Int) -> Observable<[Folder]>
  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Observable<Void>
  func deleteFolder(id: Int) -> Observable<Void>
}

final class DefaultFolderUseCase: FolderUseCase {

  // MARK: - Properties
  let repository: FolderRepository

  // MARK: - Initializer
  init(repository: FolderRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  func createFolder(requestDTO: FolderRequestDTO) -> Observable<Void> {
    repository.createFolder(requestDTO: requestDTO).asObservable()
  }
  
  func fetchFolders(start: Int, count: Int) -> Observable<[Folder]> {
    repository.fetchFolders(start: start, count: count).asObservable()
  }
  
  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Observable<Void> {
    repository.updateFolder(id: id, requestDTO: requestDTO).asObservable()
  }
  
  func deleteFolder(id: Int) -> Observable<Void> {
    repository.deleteFolder(id: id).asObservable()
  }
}
