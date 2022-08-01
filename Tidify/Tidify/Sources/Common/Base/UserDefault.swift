//
//  UserDefaultManager.swift
//  Tidify
//
//  Created by Ian on 2022/08/01.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {

  enum UserDefaultKey: String {
    case didOnboarded
    case accessToken
  }

  // MARK: - Properties
  private let key: String
  private let defaultValue: T

  // MARK: Initializer
  init(key: UserDefaultKey, defaultValue: T) {
    self.key = key.rawValue
    self.defaultValue = defaultValue
  }

  var wrappedValue: T {
    get {
      UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }

    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
