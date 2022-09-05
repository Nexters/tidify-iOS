//
//  Bookmark.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

public struct Bookmark {

  // MARK: - Properties
  private let id: Int
  private let createdAt: String
  private let updatedAt: String
  private let folderID: Int
  public let urlString: String?
  public let title: String

  public var url: URL {
    return .init(string: urlString ?? "")!
  }

  public init(
    id: Int,
    createdAt: String,
    updatedAt: String,
    folderID: Int,
    urlString: String?,
    title: String
  ) {
    self.id = id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.folderID = folderID
    self.urlString = urlString
    self.title = title
  }
}

public extension Bookmark {
  func toRequestDTO() -> BookmarkRequestDTO {
    return .init(
      folderID: folderID,
      url: urlString ?? "",
      title: title
    )
  }
}

public struct BookmarkList {

  // MARK: - Properties
  private let bookmarks: [Bookmark]
  private let count: Int

  public init(
    bookmarks: [Bookmark],
    count: Int
  ) {
    self.bookmarks = bookmarks
    self.count = count
  }
}
