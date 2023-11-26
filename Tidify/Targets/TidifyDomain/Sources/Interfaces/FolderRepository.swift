//
//  FolderRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol FolderRepository: AnyObject {
  
  //MARK: - CRUD
  func createFolder(request: FolderRequestDTO) async throws
  func fetchFolderList(start: Int, count: Int, category: Folder.FolderCategory) async throws -> FetchFolderListResponse
  func updateFolder(id: Int, request: FolderRequestDTO) async throws
  func deleteFolder(id: Int) async throws
}
