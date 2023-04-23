//
//  FolderListDTO+Mapping.swift
//  TidifyData
//
//  Created by 한상진 on 2022/10/18.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

struct FolderListResponse: Decodable, Responsable {

  // MARK: - Properties
  let message, code: String
  let folderListDTO: FolderListDTO

  enum CodingKeys: String, CodingKey {
    case folderListDTO = "data"
    case message, code
  }
}

public struct FolderListDTO: Decodable {
  let folders: [FolderDTO]
  let isLast: Bool
  let currentPage: Int

  enum CodingKeys: String, CodingKey {
    case folders = "content"
    case isLast, currentPage
  }
}

extension FolderListDTO {
  public func toDomain() -> [Folder] {
    return folders.map { $0.toDomaion() }
  }
}
