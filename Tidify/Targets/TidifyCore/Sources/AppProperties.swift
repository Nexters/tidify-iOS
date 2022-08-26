//
//  Environment.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import SwiftyBeaver

public typealias Beaver = SwiftyBeaver

public struct AppProperties {

  // MARK: - Properties
  public static let baseURL: String = "https://tidify.herokuapp.com"
  public static var authorization: String?
}
