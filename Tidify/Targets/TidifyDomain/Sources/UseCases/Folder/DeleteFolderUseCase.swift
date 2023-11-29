//
//  DeleteFolderUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/11/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol DeleteFolderUseCase {
  var folderRepository: FolderRepository { get }

  func deleteFolder(id: Int) async throws
}

extension DeleteFolderUseCase {
  func deleteFolder(id: Int) async throws {
    try await folderRepository.deleteFolder(id: id)
  }
}
