//
//  Date+.swift
//  TidifyCore
//
//  Created by Ian on 2022/09/24.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

public extension Date {
  func toString() -> String {
    let formatter: DateFormatter = .init()
    formatter.dateFormat = "yyyy-MM-dd"

    return formatter.string(from: self)
  }
}
