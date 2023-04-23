//
//  FolderUserCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public typealias FetchFoldersResponse = (folders: [Folder], isLast: Bool)

public enum FolderError: Error {
  case failFetchFolders
  case failFetchCreateFolder
  case failFetchUpdateFolder
  case failFetchDeleteFolder
}

public protocol FolderUseCase {
  func createFolder(requestDTO: FolderRequestDTO) -> Observable<Void>
  func fetchFolders(start: Int, count: Int) -> Observable<FetchFoldersResponse>
  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Observable<Void>
  func deleteFolder(id: Int) -> Observable<Void>
}

final class DefaultFolderUseCase: FolderUseCase {

  // MARK: - Properties
  private let folderRepository: FolderRepository

  // MARK: - Initializer
  init(repository: FolderRepository) {
    self.folderRepository = repository
  }

  // MARK: - Methods
  func createFolder(requestDTO: FolderRequestDTO) -> Observable<Void> {
    folderRepository.createFolder(requestDTO: requestDTO).asObservable()
  }
  
  func fetchFolders(start: Int, count: Int) -> Observable<FetchFoldersResponse> {
    return folderRepository.fetchFolders(start: start, count: count).asObservable()
  }
  
  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Observable<Void> {
    folderRepository.updateFolder(id: id, requestDTO: requestDTO).asObservable()
  }
  
  func deleteFolder(id: Int) -> Observable<Void> {
    folderRepository.deleteFolder(id: id).asObservable()
  }
}
