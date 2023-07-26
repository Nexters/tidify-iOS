//
//  DefaultFolderRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

final class DefaultFolderRepository: FolderRepository {
  
  // MARK: - Properties
  private let networkProvider: NetworkProviderType

  // MARK: - Initializer
  init(networkProvider: NetworkProviderType) {
    self.networkProvider = networkProvider
  }
  
  // MARK: - Methods
  func createFolder(request: FolderRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.createFolder(request: request), type: FolderCreationResponse.self)

    guard response.isSuccess else {
      throw FolderError.failCreateFolder
    }
  }

  func fetchFolderList(start: Int, count: Int) async throws -> FetchFolderListResponse {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.fetchFolderList(start: start, count: count), type: FolderListResponse.self)

    guard response.isSuccess else {
      throw FolderError.failFetchFolderList
    }

    return FetchFolderListResponse(
      folders: response.folderListDTO.toDomain(),
      isLast: response.folderListDTO.isLast
    )
  }
  
  func updateFolder(id: Int, request: FolderRequestDTO) async throws {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.updateFolder(id: id, request: request), type: FolderCreationResponse.self)

    guard response.isSuccess else {
      throw FolderError.failUpdateFolder
    }
  }
  
  func deleteFolder(id: Int) async throws {
    let response = try await networkProvider.request(endpoint: FolderEndpoint.deleteFolder(id: id), type: APIResponse.self)

    guard response.isSuccess else {
      throw FolderError.failDeleteFolder
    }
  }
}
