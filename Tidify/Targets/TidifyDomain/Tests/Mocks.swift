//
//  Mocks.swift
//  Tidify
//
//  Created by Ian on 2022/10/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

@testable import TidifyDomain

public extension Bookmark {
  static func stub() -> Bookmark {
    return .init(
      id: 0,
      createdAt: Date().toString(),
      updatedAt: Date().toString(),
      folderID: 0,
      urlString: "www.google.com",
      title: "Stub Data"
    )
  }
}
