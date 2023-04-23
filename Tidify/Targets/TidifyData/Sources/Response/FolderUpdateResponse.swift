//
//  FolderUpdateResponse.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

struct FolderUpdateResponse: Decodable, Responsable {

  // MARK: Properties
  let message, code: String
  let updatedFolder: UpdatedFolder

  enum CodingKeys: String, CodingKey {
    case updatedFolder = "data"
    case message, code
  }
}

struct UpdatedFolder: Decodable {

  // MARK: Properties
  let folderID: Int
  let folderName, color: String

  enum CodingKeys: String, CodingKey {
    case folderID = "folderId"
    case folderName, color
  }
}
