//
//  SettingService.swift
//  TidifyData
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya

enum SettingService {
  case trySignOut
}

extension SettingService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    return "/oauth2/withdrawal"
  }

  var method: Moya.Method {
    return .delete
  }

  var sampleData: Data {
    return .init()
  }

  var task: Task {
    return .requestPlain
  }

  var headers: [String : String]? {
    [
      "X-Auth-Token": AppProperties.accessToken,
      "refreshToken": AppProperties.refreshToken
    ]
  }
}
