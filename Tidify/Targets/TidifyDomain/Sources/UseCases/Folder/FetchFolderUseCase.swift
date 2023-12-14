//
//  FetchFolderUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/11/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

public typealias FetchFolderListResponse = (folders: [Folder], isLast: Bool)

public protocol FetchFolderUseCase {
  var folderRepository: FolderRepository { get }

  func fetchFolderList(start: Int, count: Int, category: FolderCategory) async throws -> FetchFolderListResponse
}

extension FetchFolderUseCase {
  func fetchFolderList(start: Int, count: Int, category: FolderCategory) async throws -> FetchFolderListResponse {
    try await folderRepository.fetchFolderList(start: start, count: count, category: category)
  }
}
