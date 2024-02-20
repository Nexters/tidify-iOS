//
//  Folder.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public enum FolderCategory {
  case normal, subscribe, share
}

public struct Folder: Equatable {
  public let id: Int
  public var title: String
  public var color: String
  public let count: Int
  public var isShared: Bool = false
  
  public init(id: Int, title: String, color: String, count: Int) {
    self.id = id
    self.title = title
    self.color = color
    self.count = count
  }

  public static func ==(lhs: Folder, rhs: Folder) -> Bool {
    lhs.id == rhs.id && lhs.title == rhs.title && lhs.color == rhs.color
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
