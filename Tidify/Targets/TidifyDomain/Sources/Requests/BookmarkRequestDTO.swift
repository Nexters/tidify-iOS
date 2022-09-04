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
}
