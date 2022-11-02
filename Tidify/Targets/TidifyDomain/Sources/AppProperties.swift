//
//  Environment.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyCore

public struct AppProperties {

  // MARK: - Properties
  public static var baseURL: String {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let baseURL = infoDictionary["BASE_URL"] as? String
    else { return .init() }
    return "http://\(baseURL)"
  }
  
  public static var domainURL: String {
    guard let domainURL = baseURL.components(separatedBy: "//").last?.split(separator: ":")
      .map({ String($0) }).first
    else { return .init() }
    return domainURL
  }
  
  public static var accessToken: String {
    guard let accessTokenData = KeyChain.load(key: .accessToken) else { return .init() }
    return String(decoding: accessTokenData, as: UTF8.self)
  }
  
  public static var refreshToken: String {
    guard let refreshTokenData = KeyChain.load(key: .refreshToken) else { return .init() }
    return String(decoding: refreshTokenData, as: UTF8.self)
  }
  
  public static var userAgent: String {
    guard let infoDictionary = Bundle.main.infoDictionary,
          let userAgent = infoDictionary["USER_AGENT"] as? String
    else { return .init() }
    return userAgent
  }
}
