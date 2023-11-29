//
//  FolderCreationUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/11/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

public enum FolderCreationError: Error {
  case failCreateFolder
  case failUpdateFolder
}

public protocol FolderCreationUseCase {
  func createFolder(request: FolderRequestDTO) async throws
  func updateFolder(id: Int, request: FolderRequestDTO) async throws
}

final class DefaultFolderCreationUseCase: FolderCreationUseCase {

  // MARK: - Properties
  private let folderRepository: FolderRepository

  // MARK: - Initializer
  init(repository: FolderRepository) {
    self.folderRepository = repository
  }

  func createFolder(request: FolderRequestDTO) async throws {
    try await folderRepository.createFolder(request: request)
  }

  func updateFolder(id: Int, request: FolderRequestDTO) async throws {
    try await folderRepository.updateFolder(id: id, request: request)
  }
}
