//
//  UserSessionDTO.swift
//  TidifyData
//
//  Created by Ian on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct UserSessionDTO: Decodable {
  let authorization: String

  enum CodingKeys: String, CodingKey {
    case authorization = "Authorization"
  }
}

extension UserSessionDTO {
  func toDomain() -> UserSession {
    .init(authorization: authorization)
  }
}
