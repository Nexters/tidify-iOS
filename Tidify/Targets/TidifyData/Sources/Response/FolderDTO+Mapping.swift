//
//  FolderDTO.swift
//  TidifyData
//
//  Created by 한상진 on 2022/10/18.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

public struct FolderDTO: Decodable {

  // MARK: - Properties
  let folderID: Int
  let folderName, color: String
  let count: Int

  enum CodingKeys: String, CodingKey {
      case folderID = "folderId"
      case folderName, color, count
  }
}

extension FolderDTO {
  public func toDomaion() -> Folder {
    .init(id: folderID, title: folderName, color: color)
  }
}
