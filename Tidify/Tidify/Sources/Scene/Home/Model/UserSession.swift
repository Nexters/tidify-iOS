//
//  UserSession.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import Foundation

struct UserSessionDTO: Codable {
  let authorization: String!

  enum CodingKeys: String, CodingKey {
    case authorization = "Authorization"
  }
}

struct UserSession: Codable {
  let accessToken: String!
  let uid: String? = nil

  enum CodingKeys: String, CodingKey {
    case uid
    case accessToken = "access_token"
  }
}
