//
//  Optional+.swift
//  TidifyCore
//
//  Created by 여정수 on 2023/09/28.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

public extension Optional {
  var isNil: Bool {
    return self == nil
  }

  var isNotNil: Bool {
    return self != nil
  }
}
