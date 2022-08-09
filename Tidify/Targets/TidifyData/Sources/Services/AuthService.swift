//
//  AuthService.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya

enum AuthService {
  case auth(socialLoginType: SocialLoginType, accessToken: String, refreshToken: String)
}

extension AuthService: TargetType {
  var baseURL: URL {
    return URL(string: "https://tidify.herokuapp.com")!
  }

  var path: String {
    let baseRoutePath = "/api/v1/oauth"

    switch self {
    case .auth:
      return baseRoutePath
    }
  }

  var method: Moya.Method {
    switch self {
    case .auth:
      return .post
    }
  }

  var sampleData: Data {
    return .init()
  }

  var task: Task {
    let requestParameters = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put:
      encoding = JSONEncoding.default
    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParameters, encoding: encoding)
  }

  var headers: [String: String]? {
    return nil
  }

  private var parameters: [String: Any]? {
    switch self {
    case let .auth(socialLoginType, accessToken, refreshToken):
      return ["sns_type": socialLoginType.rawValue,
              "access_token": accessToken,
              "refresh_token": refreshToken]
    }
  }
}
