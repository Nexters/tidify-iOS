//
//  BookmarkListDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

struct BookmarkListResponse: Decodable, Responsable {

  // MARK: Properties
  let code, message: String
  let bookmarkListDTO: BookmarkListDTO

  enum CodingKeys: String, CodingKey {
    case code, message
    case bookmarkListDTO = "data"
  }
}

extension BookmarkListResponse {
  public func toDomain() -> [Bookmark] {
    bookmarkListDTO.bookmarks.map { $0.toDomain() }
  }
}

public struct BookmarkListDTO: Decodable {

  // MARK: - Properties
  public let bookmarks: [BookmarkDTO]
  public let isLastPage: Bool
  public let currentPage: Int

  enum CodingKeys: String, CodingKey {
    case bookmarks = "content"
    case isLastPage = "isLast"
    case currentPage
  }
}
