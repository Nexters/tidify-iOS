//
//  UserTokenDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

struct UserTokenDTO: Decodable, Responsable {

  // MARK: - Properties
  let accessToken: String
  let refreshToken: String
  let key: String
  let oAuthType: String

  enum CodingKeys: String, CodingKey {
    case accessToken, refreshToken, key
    case oAuthType = "type"
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
