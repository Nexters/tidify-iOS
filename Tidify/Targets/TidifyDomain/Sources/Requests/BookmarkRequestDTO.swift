//
//  BookmarkRequestDTO.swift
//  TidifyDomain
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct BookmarkRequestDTO: Encodable {

  // MARK: - Properties
  public let folderID: Int
  public let url: String
  public let title: String

  public init (folderID: Int = 0, url: String, title: String) {
    self.folderID = folderID
    self.url = url
    self.title = title
  }
}
