//
//  UserTokenDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

struct UserTokenDTO: Decodable {
  let accessToken: String
  let refreshToken: String
  let response: APIResponse

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case refreshToken = "refresh_token"
    case response = "api_response"
  }
}

extension UserTokenDTO {
  func toDomain() -> UserToken {
    return .init(
      accessToken: accessToken,
      refreshToken: refreshToken
    )
  }
}
