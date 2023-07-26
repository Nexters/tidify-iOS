//
//  SettingEndpoint.swift
//  TidifyData
//
//  Created by 한상진 on 2023/07/27.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

enum SettingEndpoint: EndpointType {
  case signOut
}

extension SettingEndpoint {
  var baseRouthPath: String {
    return "/oauth2/withdrawal"
  }

  var fullPath: String {
    return .init()
  }

  var method: HTTPMethod {
    return .delete
  }

  var parameters: [String : String]? {
    return nil
  }
}
