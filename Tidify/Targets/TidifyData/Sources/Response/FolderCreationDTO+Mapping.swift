//
//  FolderCreationDTO+Mapping.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain

struct FolderCreationResponse: Decodable, Responsable {

  // MARK: Properties
  let message, code: String
  let folderCreationDTO: FolderCreationDTO

  enum CodingKeys: String, CodingKey {
    case folderCreationDTO = "data"
    case message, code
  }
}

struct FolderCreationDTO: Decodable {

  // MARK: Properties
  let folderID: Int
  let folderName, color: String

  enum CodingKeys: String, CodingKey {
    case folderID = "folderId"
    case folderName, color
  }
}

extension FolderCreationDTO {
  public func toDomain() -> Folder {
    .init(id: folderID, title: folderName, color: color, count: 0, category: .normal)
  }
}
