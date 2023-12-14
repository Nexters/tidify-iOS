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
  init(networkProvider: NetworkProviderType = NetworkProvider()) {
    self.networkProvider = networkProvider
  }
  
  // MARK: - Methods
  func createFolder(request: FolderRequestDTO) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.createFolder(request: request), type: FolderCreationResponse.self)
  }

  func fetchFolderList(start: Int, count: Int, category: FolderCategory) async throws -> FetchFolderListResponse {
    let response = try await networkProvider.request(
      endpoint: FolderEndpoint.fetchFolderList(start: start, count: count, category: category),
      type: FolderListResponse.self
    )

    return FetchFolderListResponse(
      folders: response.folderListDTO.toDomain(),
      isLast: response.folderListDTO.isLast
    )
  }
  
  func updateFolder(id: Int, request: FolderRequestDTO) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.updateFolder(id: id, request: request), type: FolderCreationResponse.self)
  }
  
  func deleteFolder(id: Int) async throws {
    try await networkProvider.request(endpoint: FolderEndpoint.deleteFolder(id: id), type: APIResponse.self)
  }
}
