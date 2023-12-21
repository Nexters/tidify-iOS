//
//  BookmarkDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

struct BookmarkResponse: Decodable, Responsable {

  // MARK: Properties
  let code, message: String
  let bookmarkDTO: BookmarkDTO

  enum CodingKeys: String, CodingKey {
    case code, message
    case bookmarkDTO = "data"
  }
}

public struct BookmarkDTO: Decodable {

  // MARK: - Properties
  let id: Int
  let folderID: Int?
  let urlString: String?
  let name: String
  let star: Bool

  enum CodingKeys: String, CodingKey {
    case id = "bookmarkId"
    case folderID = "folderId"
    case urlString = "url"
    case name, star
  }
}

extension BookmarkDTO {
  public func toDomain() -> Bookmark {
    .init(
      id: id,
      folderID: folderID,
      urlString: urlString,
      name: name,
      star: star
    )
  }
}
