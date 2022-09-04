//
//  BookmarkRequestDTO.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct BookmarkRequestDTO: Encodable {

  // MARK: - Properties
  let folderID: Int
  let url: String
  let title: String
}
