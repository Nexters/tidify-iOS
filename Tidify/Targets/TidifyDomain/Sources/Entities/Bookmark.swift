//
//  Bookmark.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public enum BookmarkCategory {
  case normal, favorite
}

public struct Bookmark: Hashable {

  // MARK: - Properties
  public let id: Int
  public var folderID: Int?
  public var urlString: String?
  public var name: String
  public var star: Bool

  public var url: URL {
    return .init(string: urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
  }

  public init(
    id: Int,
    folderID: Int?,
    urlString: String?,
    name: String,
    star: Bool
  ) {
    self.id = id
    self.folderID = folderID
    self.urlString = urlString
    self.name = name
    self.star = star
  }

  public static func ==(lhs: Bookmark, rhs: Bookmark) -> Bool {
    lhs.id == rhs.id && lhs.folderID == rhs.folderID && lhs.urlString == rhs.urlString && lhs.name == rhs.name
  }
}

public extension Bookmark {
  func toRequestDTO() -> BookmarkRequestDTO {
    return .init(
      folderID: folderID ?? 0,
      url: urlString ?? "",
      name: name
    )
  }

  mutating func update(with requestDTO: BookmarkRequestDTO) {
    self.name = requestDTO.name
    self.urlString = requestDTO.url
    self.folderID = requestDTO.folderID
  }

  func openURL() {
    var urlString: String = urlString ?? ""
    if !(urlString.contains("http://") || urlString.contains("https://")) {
      urlString = "https://" + urlString
    }

    guard let url = URL(string: urlString) else {
      return
    }

    UIApplication.shared.open(url)
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
