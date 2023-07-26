//
//  FolderUserCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public typealias FetchFolderListResponse = (folders: [Folder], isLast: Bool)

public enum FolderError: Error {
  case failFetchFolderList
  case failCreateFolder
  case failUpdateFolder
  case failDeleteFolder
  case emptyFolderTitle
  case emptyColorValue
  case emptyMatchedFolder
}

public protocol FolderUseCase {
  func createFolder(request: FolderRequestDTO) async throws
  func fetchFolderList(start: Int, count: Int) async throws -> FetchFolderListResponse
  func updateFolder(id: Int, request: FolderRequestDTO) async throws
  func deleteFolder(id: Int) async throws
}

final class DefaultFolderUseCase: FolderUseCase {

  // MARK: - Properties
  private let folderRepository: FolderRepository

  // MARK: - Initializer
  init(repository: FolderRepository) {
    self.folderRepository = repository
  }

  // MARK: - Methods
  func createFolder(request: FolderRequestDTO) async throws {
    try await folderRepository.createFolder(request: request)
  }
  
  func fetchFolderList(start: Int, count: Int) async throws -> FetchFolderListResponse {
    try await folderRepository.fetchFolderList(start: start, count: count)
  }
  
  func updateFolder(id: Int, request: FolderRequestDTO) async throws {
    try await folderRepository.updateFolder(id: id, request: request)
  }
  
  func deleteFolder(id: Int) async throws {
    try await folderRepository.deleteFolder(id: id)
  }
}
