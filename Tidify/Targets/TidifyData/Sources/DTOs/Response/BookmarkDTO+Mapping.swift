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
  let createdAt: String
  let updatedAt: String
  let email: String
  let folderID: Int
  let urlString: String?
  let title: String

  enum CodingKeys: String, CodingKey {
    case id = "bookmark_id"
    case createdAt = "CreatedAt"
    case updatedAt = "UpdatedAt"
    case email = "user_email"
    case folderID = "folder_id"
    case urlString = "bookmark_url"
    case title = "bookmark_title"
  }
}

extension BookmarkDTO {
  public func toDomaion() -> Bookmark {
    .init(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      folderID: folderID,
      urlString: urlString,
      title: title
    )
  }
}
