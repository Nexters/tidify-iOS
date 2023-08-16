//
//  UserProperties.swift
//  TidifyCore
//
//  Created by 여정수 on 2023/08/04.
//  Copyright © 2023 Tidify. All rights reserved.
//

public struct UserProperties {
  @UserDefaultsStorage (key: .isFirstLaunch, defaultValue: false)
  public static var isFirstLaunch: Bool

  @UserDefaultsStorage(key: .searchHistory, defaultValue: [])
  public static var searchHistory: [String]
}
