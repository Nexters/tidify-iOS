//
//  Storage.swift
//  TidifyCore
//
//  Created by Ian on 2022/11/01.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

/// UserDefaults Wrapper
@propertyWrapper
public struct Storage<T> {

  // MARK: - Properties
  public enum StorageKey: String, CaseIterable {
    case isFirstLaunch = "isFirstLaunch"
  }

  private let key: StorageKey
  private var defaultValue: T

  public var wrappedValue: T {
    get {
      return UserDefaults.standard.value(forKey: key.rawValue) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: key.rawValue)
    }
  }

  // MARK: - Initializer
  public init(key: StorageKey, defaultValue: T) {
    self.key = key
    self.defaultValue = defaultValue
  }
}

public struct UserDefaultsStorage {
  @Storage(key: .isFirstLaunch, defaultValue: true)
  public static var isFirstLaunch: Bool
}
