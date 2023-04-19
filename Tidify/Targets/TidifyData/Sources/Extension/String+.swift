//
//  String+.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

public extension String {

  // MARK: Properties
  var isSuccess: Bool {
    self == APIResponse.ResponseCode.success.rawValue
  }
}
