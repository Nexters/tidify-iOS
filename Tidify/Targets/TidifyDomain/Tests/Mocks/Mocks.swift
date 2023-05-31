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
  static func stubList() -> [Bookmark] {
    return [
      .init(id: 0, folderID: 0, urlString: "www.google.com", name: "Google"),
      .init(id: 1, folderID: 0, urlString: "https://duwjdtn11.tistory.com", name: "Tistory"),
      .init(id: 2, folderID: nil, urlString: "https://github.com/iannealer", name: "Github")
    ]
  }
}

public extension Folder {
  static func stubList() -> [Folder] {
    return [
      .init(id: 0, title: "Folder1", color: "#242132"),
      .init(id: 1, title: "Folder2", color: "#44ff12")
    ]
  }
}
