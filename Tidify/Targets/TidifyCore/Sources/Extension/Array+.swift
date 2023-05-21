//
//  Array+.swift
//  TidifyCore
//
//  Created by 여정수 on 2023/05/21.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

public extension Array {
  subscript (safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}
