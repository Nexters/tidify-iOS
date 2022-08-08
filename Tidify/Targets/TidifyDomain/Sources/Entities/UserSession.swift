//
//  UserSession.swift
//  TidifyCore
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct UserSession: Decodable {
  let authorization: String

  enum CodingKeys: String, CodingKey {
    case authorization = "Authorization"
  }
}
