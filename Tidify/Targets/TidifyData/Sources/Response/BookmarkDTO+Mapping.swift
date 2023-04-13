//
//  BookmarkDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

public struct BookmarkDTO: Decodable {

  // MARK: - Properties
  let id: Int
  let folderID: Int
  let urlString: String?
  let name: String

  enum CodingKeys: String, CodingKey {
    case id = "bookmarkId"
    case folderID = "folderId"
    case urlString = "url"
    case name = "name"
  }
}

extension BookmarkDTO {
  public func toDomain() -> Bookmark {
    .init(
      id: id,
      folderID: folderID,
      urlString: urlString,
      name: name
    )
  }
}
