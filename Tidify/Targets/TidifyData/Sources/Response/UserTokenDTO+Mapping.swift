//
//  UserTokenDTO+Mapping.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

//import TidifyDomain
//
//struct UserResponse: Decodable, Responsable {
//
//  // MARK: - Properties
//  let message, code: String
//  let userTokenDTO: UserTokenDTO
//
//  enum CodingKeys: String, CodingKey {
//    case code, message
//    case userTokenDTO = "data"
//  }
//}
//
//extension UserResponse {
//  func toDomain() -> UserToken {
//    return .init(
//      accessToken: userTokenDTO.accessToken,
//      refreshToken: userTokenDTO.refreshToken
//    )
//  }
//}
//
//struct UserTokenDTO: Decodable {
//
//  // MARK: - Properties
//  let accessToken, refreshToken, email, socialType: String
//
//  enum CodingKeys: String, CodingKey {
//    case accessToken, refreshToken
//    case email = "key"
//    case socialType = "type"
//  }
//}
import TidifyDomain

struct UserResponse: Decodable {

  // MARK: - Properties
  let accessToken, refreshToken, email, socialType: String

  enum CodingKeys: String, CodingKey {
    case accessToken, refreshToken
    case email = "key"
    case socialType = "type"
  }
}

extension UserResponse {
  func toDomain() -> UserToken {
    return .init(
      accessToken: accessToken,
      refreshToken: refreshToken
    )
  }
}
