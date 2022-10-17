//
//  FolderListDTO+Mapping.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/10/18.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

public struct FolderListDTO: Decodable {

  // MARK: - Properties
  let folders: [FolderDTO]
  let totalCount: Int
  let apiResponse: APIResponse

  enum CodingKeys: String, CodingKey {
      case folders = "list"
      case totalCount = "total_count"
      case apiResponse = "api_response"
  }
}

extension FolderListDTO {
  public func toDomain() -> [Folder] {
    return folders.map { $0.toDomaion() }
  }
}
