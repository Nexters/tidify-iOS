//
//  FolderRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public protocol FolderRepository {
  
  //MARK: - 추후 실서버 연동 후 변경 예정
  func createFolder(name: String, color: String) -> Folder
  func updateFolder(name: String, color: String)
  func deleteFolder(folderID: Int)
  func fetchFolders() -> [Folder]?
}
