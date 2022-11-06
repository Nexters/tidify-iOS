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
  case apple(token: String)
  case updateToken
}

extension AuthService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    switch self {
    case .apple: return "/auth/apple"
    case .updateToken: return "/updateToken"
    }
  }

  var method: Moya.Method {
    switch self {
    case .apple: return .post
    case .updateToken: return .get
    }
  }

  var sampleData: Data {
    return .init()
  }

  var task: Task {
    let requestParameters = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .get:
      return .requestPlain
    case .post, .patch, .put:
      encoding = JSONEncoding.default
    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParameters, encoding: encoding)
  }

  var headers: [String : String]? {
    switch self {
    case .updateToken:
      return ["refresh-token": AppProperties.refreshToken]
    case .apple:
      return nil
    }
  }

  private var parameters: [String: Any]? {
    switch self {
    case .apple(let token): return ["id_token": token]
    case .updateToken: return nil
    }
  }
}
