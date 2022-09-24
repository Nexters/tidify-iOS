//
//  Mocks.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/08/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

@testable import TidifyDomain

import Foundation

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
