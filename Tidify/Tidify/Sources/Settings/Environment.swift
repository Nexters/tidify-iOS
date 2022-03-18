//
//  Environment.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation

class Environment {

  // MARK: - Properties

  static let shared = Environment()

  let baseURL: String = "https://tidify.herokuapp.com"

  var authorization: String?

  private init() { }
}
