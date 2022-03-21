//
//  Folder.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation

struct Folder: Codable {
  let name: String
  let color: String
  
  enum CodingKeys: String, CodingKey {
    case name
    case color
  }
}
