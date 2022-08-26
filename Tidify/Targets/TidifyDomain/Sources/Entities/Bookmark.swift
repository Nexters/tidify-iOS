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
  private let memberID: Int
  public let urlString: String?
  public let title: String
  public let tag: String

  public var url: URL {
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
