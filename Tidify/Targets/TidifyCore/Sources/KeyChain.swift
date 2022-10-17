//
//  KeyChain.swift
//  TidifyCore
//
//  Created by 한상진 on 2022/10/17.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import Security

public final class KeyChain {
  public static func save(key: String, data: Data) {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data
    ])
    SecItemDelete(query)
    SecItemAdd(query, nil)
  }
  
  public static func load(key: String) -> Data? {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
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
  
  public static func delete(key: String) {
    let query: NSDictionary = .init(dictionary: [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key
    ])
    SecItemDelete(query)
  }
}
