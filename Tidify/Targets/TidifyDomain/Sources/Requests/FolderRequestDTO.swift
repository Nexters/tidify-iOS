//
//  FolderRequestDTO.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/10/18.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct FolderRequestDTO: Encodable {
  public let title: String
  public let color: String
  
  public init(title: String, color: String) {
    self.title = title
    self.color = color
  }
  
  enum CodingKeys: String, CodingKey {
    case title = "folder_title"
    case color = "folder_color"
  }
}
