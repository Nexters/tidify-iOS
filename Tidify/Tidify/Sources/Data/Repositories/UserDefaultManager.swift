//
//  UserDefaultManager.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/15.
//

import Foundation
import UIKit

enum UserDefaultManager {
  @UserDefault(key: .didOnboarded, defaultValue: false)
  static var didOnboarded: Bool

  @UserDefault(key: .accessToken, defaultValue: "")
  static var accessToken
}
