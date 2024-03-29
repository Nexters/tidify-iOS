//
//  VIewModelType.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/08/25.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

public protocol ViewModelType {

  // MARK: associatedtype
  associatedtype Action
  associatedtype State

  // MARK: Properties
  var state: State { get }

  // MARK: Methods
  func action(_ action: Action)
}
