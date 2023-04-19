//
//  FolderService.swift
//  TidifyData
//
//  Created by 한상진 on 2022/10/18.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya

enum FolderService {
  case createFolder(_ requestDTO: FolderRequestDTO)
  case fetchFolders(start: Int = 0, count: Int = 10)
  case deleteFolder(id: Int)
  case updateFolder(id: Int, requestDTO: FolderRequestDTO)
}

extension FolderService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }
  
  var path: String {
    let baseRoutePath: String = "/app/folders"

    switch self {
    case let .updateFolder(id, _): return baseRoutePath + "/\(id)"
    case .deleteFolder(let id): return baseRoutePath + "/\(id)"
    default: return baseRoutePath
    }
  }

  var method: Moya.Method {
    switch self {
    case .createFolder:
      return .post
    case .fetchFolders:
      return .get
    case .updateFolder:
      return .patch
    case .deleteFolder:
      return .delete
    }
  }

  var task: Task {
    switch self {
    case .createFolder(let requestDTO):
      return .requestJSONEncodable(requestDTO)
      
    case .fetchFolders(let start, let count):
      let param: [String: Any] = ["page": start, "size": count]
      return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
      
    case .updateFolder(_, let requestDTO):
      let param: [String: Any] = [
        "folderName": requestDTO.title,
        "label": requestDTO.color
      ]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
      
    case .deleteFolder:
      return .requestPlain
    }
  }

  var headers: [String : String]? {
    [
      "X-Auth-Token": AppProperties.accessToken,
      "refreshToken": AppProperties.refreshToken
    ]
  }
}
