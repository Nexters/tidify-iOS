//
//  Folder.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct Folder {
  public let id: Int
  public var title: String
  public var color: String
  
  public init(id: Int, title: String, color: String) {
    self.id = id
    self.title = title
    self.color = color
  }
}

public extension Folder {
  func toRequestDTO() -> FolderRequestDTO {
    return .init(title: title, color: color)
  }

  mutating func updateFolder(with requestDTO: FolderRequestDTO) {
    self.title = requestDTO.title
    self.color = requestDTO.color
  }
}
