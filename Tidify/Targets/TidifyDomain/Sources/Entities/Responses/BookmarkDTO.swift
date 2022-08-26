//
//  BookmarkDTO.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct BookmarkDTO: Decodable {

  // MARK: - Properties
  let id: Int
  let createdAt: String
  let updatedAt: String
  let memberID: Int
  let urlString: String?
  let title: String
  let tag: String

  enum CodingKeys: String, CodingKey {
    case id
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case memberID = "member_id"
    case urlString = "url"
    case title
    case tag
  }
}

extension BookmarkDTO {
  public func toDomain() -> Bookmark {
    .init(
      id: id,
      createdAt: createdAt,
      updatedAt: updatedAt,
      memberID: memberID,
      urlString: urlString,
      title: title,
      tag: tag
    )
  }
}

public struct BookmarkListDTO: Decodable {
  public let bookmarks: [BookmarkDTO]
  public let bookmarksCount: Int

  enum CodingKeys: String, CodingKey {
    case bookmarks
    case bookmarksCount = "bookmarks_count"
  }
}
