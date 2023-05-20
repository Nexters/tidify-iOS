//
//  SignInService.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya

enum SignInService {
  case apple(token: String)
  case tryKakaoSignIn(accessToken: String)

}

extension SignInService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    switch self {
    case .apple: return "/oauth2/login"
    case .tryKakaoSignIn: return "/oauth2/login"
    }
  }

  var method: Moya.Method {
    switch self {
    case .apple: return .get
    case .tryKakaoSignIn: return .get
    }
  }

  var sampleData: Data {
    return .init()
  }

  var task: Task {
    let requestParameters = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put, .delete:
      encoding = JSONEncoding.default

    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParameters, encoding: encoding)
  }

  var headers: [String : String]? {
    switch self {
    case .apple(let token):
      return ["Authorization": token]
    case .tryKakaoSignIn(let accessToken):
      return ["Authorization": accessToken]
    }
  }

  private var parameters: [String: Any]? {
    switch self {
    case .apple: return ["type": "APPLE"]
    case .tryKakaoSignIn: return ["type": "KAKAO"]
    }
  }
}