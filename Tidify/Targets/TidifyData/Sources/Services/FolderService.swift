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
  case fetchFolders(start: Int = 0, count: Int = 100, keyword: String? = nil)
  case deleteFolder(id: Int)
  case updateFolder(id: Int, requestDTO: FolderRequestDTO)
}

extension FolderService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }
  
  var path: String {
    return "/folders"
  }

  var method: Moya.Method {
    switch self {
    case .createFolder:
      return .post
    case .fetchFolders:
      return .get
    case .updateFolder:
      return .put
    case .deleteFolder:
      return .delete
    }
  }

  var task: Task {
    switch self {
    case .createFolder(let requestDTO):
      return .requestJSONEncodable(requestDTO)
      
    case .fetchFolders(let start, let count, let keyword):
      var param: [String: Any] = ["start": start, "count": count]
      if let keyword = keyword { param["keyword"] = keyword }
      return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
      
    case .updateFolder(let id, let requestDTO):
      let param: [String: Any] = [
        "folder_id": id,
        "folder_title": requestDTO.title,
        "folder_color": requestDTO.color
      ]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
      
    case .deleteFolder(let id):
      let param: [String: Any] = ["folder_id": id]
      return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
  }

  var headers: [String : String]? {
    ["access-token": AppProperties.accessToken]
  }
}
