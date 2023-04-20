//
//  Responsable.swift
//  TidifyData
//
//  Created by 여정수 on 2023/04/20.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation

protocol Responsable {
  var code: String { get }
  var message: String { get }
}

extension Responsable where Self: Decodable {
  var isSuccess: Bool {
    code == "200" && message == "success"
  }
}
