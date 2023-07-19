//
//  BookmarkListRequestDTO.swift
//  TidifyDomain
//
//  Created by 여정수 on 2023/04/20.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

public struct BookmarkListRequestDTO: Encodable {

  // MARK: Properties
  public let page: Int
  public let size: Int
  public let keyword: String?

  // MARK: Initializer
  public init(page: Int, size: Int = 20, keyword: String? = nil) {
    self.page = page
    self.size = size
    self.keyword = keyword
  }
}
