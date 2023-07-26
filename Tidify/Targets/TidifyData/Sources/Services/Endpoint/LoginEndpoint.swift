//
//  LoginEndpoint.swift
//  TidifyData
//
//  Created by 한상진 on 2023/07/27.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

enum LoginEndpoint: EndpointType {
  case appleLogin(token: String)
  case kakaoLogin(token: String)
}

extension LoginEndpoint {
  var baseRouthPath: String {
    return "/oauth2/login"
  }

  var fullPath: String {
    return .init()
  }

  var method: HTTPMethod {
    return .get
  }

  var parameters: [String : String]? {
    switch self {
    case .appleLogin:
      return ["type": "APPLE"]
    case .kakaoLogin:
      return ["type": "KAKAO"]
    }
  }

  var headers: [String : String]? {
    switch self {
    case .appleLogin(let token), .kakaoLogin(let token):
      return ["Authorization": token]
    }
  }
}
