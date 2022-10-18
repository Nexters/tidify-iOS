//
//  KeyChain.swift
//  TidifyCore
//
//  Created by 한상진 on 2022/10/17.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import Security

public enum AppData: String {
  case baseURL = "BASE_URL"
  case accessToken = "accessToken"
  case refreshToken = "refreshToken"
  case userAgent = "USER_AGENT"
}

public enum KeyChain {
  public static func save(key: AppData, data: Data) {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecValueData: data
    ])
    SecItemDelete(query)
    SecItemAdd(query, nil)
  }
  
  public static func load(key: AppData) -> Data? {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne
    ])
    var dataTypeReference: AnyObject?
    let status = withUnsafeMutablePointer(to: &dataTypeReference) {
      SecItemCopyMatching(query, UnsafeMutablePointer($0))
    }
    
    guard status == errSecSuccess,
          let data = dataTypeReference as? Data
    else { return nil }
    
    return data
  }
  
  public static func delete(key: AppData) {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key.rawValue
    ])
    SecItemDelete(query)
  }
}
