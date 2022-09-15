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
  case kakao
  case google
  case apple(token: String)
}

extension AuthService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    let baseRoutePath = "/auth"

    switch self {
    case .kakao:
      return baseRoutePath + "/kakao"
    case .google:
      return baseRoutePath + "/google"
    case .apple:
      return baseRoutePath + "/apple"
    }
  }

  var method: Moya.Method {
    switch self {
    case .kakao, .google:
      return .get
    case .apple:
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
    case .kakao, .google:
      return nil

    case .apple(let token):
      return [
        "id_token": token
      ]
    }
  }
}
