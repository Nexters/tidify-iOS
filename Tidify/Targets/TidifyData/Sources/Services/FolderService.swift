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
      guard let param: Encodable = [
        "folder_id": id,
        "folder_title": requestDTO.title,
        "folder_color": requestDTO.color
      ] as? [String: String] else { break }
      return .requestJSONEncodable(param)
      
    case .deleteFolder(let id):
      guard let param: Encodable = ["folder_id": id] as? [String: String] else { break }
      return .requestJSONEncodable(param)
    }
    
    return .requestPlain
  }

  var headers: [String : String]? { return nil }
}
