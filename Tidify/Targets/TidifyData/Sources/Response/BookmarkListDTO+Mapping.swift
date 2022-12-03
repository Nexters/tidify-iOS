//
//  BookmarkListDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

public struct BookmarkListDTO: Decodable {

  // MARK: - Properties
  public let bookmarks: [BookmarkDTO]
  public let count: Int
  public let response: APIResponse

  enum CodingKeys: String, CodingKey {
    case bookmarks = "list"
    case count = "total_count"
    case response = "api_response"
  }
}

extension BookmarkListDTO {
  public func toDomain() -> [Bookmark] {
    return bookmarks.map { $0.toDomaion() }
  }
}
