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
  let createdAt, updatedAt, userEmail: String
  let id: Int
  let title, color: String

  enum CodingKeys: String, CodingKey {
      case createdAt = "CreatedAt"
      case updatedAt = "UpdatedAt"
      case userEmail = "user_email"
      case id = "folder_id"
      case title = "folder_title"
      case color = "folder_color"
  }
}

extension FolderDTO {
  public func toDomaion() -> Folder {
    .init(id: id, title: title, color: color)
  }
}
