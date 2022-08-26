//
//  Folder.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct Folder {
  //TODO: 서버 연동 후 수정 예정
  public private(set) var name: String
  public private(set) var color: String
  public private(set) var bookMarks: [Bookmark]?
  
  public init(name: String, color: String, bookMarks: [Bookmark]? = nil) {
    self.name = name
    self.color = color
    self.bookMarks = bookMarks
  }
}
