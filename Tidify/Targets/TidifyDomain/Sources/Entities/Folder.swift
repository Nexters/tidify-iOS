//
//  Folder.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct Folder: Equatable {
  public let id: Int
  public var title: String
  public var color: String
  public let count: Int
  public let category: FolderCategory
  
  public init(id: Int, title: String, color: String, count: Int, category: FolderCategory) {
    self.id = id
    self.title = title
    self.color = color
    self.count = count
    self.category = category
  }

  public enum FolderCategory {
    case normal, subscribe, share
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
