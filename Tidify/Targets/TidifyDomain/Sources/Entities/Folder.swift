//
//  Folder.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct Folder {
  let name: String
  let color: String
  let bookMarks: [BookMark]?
  
  public init(name: String, color: String, bookMarks: [BookMark]? = nil) {
    self.name = name
    self.color = color
    self.bookMarks = bookMarks
  }
}
