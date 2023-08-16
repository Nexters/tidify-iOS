//
//  UserEndpoint.swift
//  TidifyData
//
//  Created by 한상진 on 2023/07/27.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

enum SocialType {
  case kakao(token:String)
  case apple(token: String)
}

enum UserEndpoint: EndpointType {
  case signIn(socialType: SocialType)
  case signOut
}

extension UserEndpoint {
  var baseRouthPath: String {
    return "/oauth2"
  }

  var fullPath: String {
    switch self {
    case .signIn:
      return "/login"
    case .signOut:
      return "/withdrawal"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .signIn:
      return .get
    case .signOut:
      return .delete
    }
  }

  var parameters: [String : String]? {
    switch self {
    case .signIn(let socialType):
      switch socialType {
      case .kakao:
        return ["type": "KAKAO"]
      case .apple:
        return ["type": "APPLE"]
      }

    case .signOut:
      return nil
    }
  }

  var headers: [String : String]? {
    switch self {
    case .signIn(let socialType):
      switch socialType {
      case .apple(let token), .kakao(let token):
        return ["Authorization": token]
      }

    case .signOut:
      return nil
    }
  }
}
