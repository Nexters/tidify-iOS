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
  let id: Int
  let createdAt: String
  let updatedAt: String
  let memberID: Int
  let urlString: String?
  let title: String
  let tag: String

  var url: URL {
    return .init(string: urlString ?? "")!
  }

  public init(
    id: Int,
    createdAt: String,
    updatedAt: String,
    memberID: Int,
    urlString: String?,
    title: String,
    tag: String
  ) {
    self.id = id
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.memberID = memberID
    self.urlString = urlString
    self.title = title
    self.tag = tag
  }
}
