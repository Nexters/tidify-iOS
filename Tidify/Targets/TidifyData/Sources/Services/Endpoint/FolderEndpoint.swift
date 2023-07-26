//
//  FolderEndpoint.swift
//  TidifyData
//
//  Created by 한상진 on 2023/07/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

enum FolderEndpoint: EndpointType {
  case createFolder(request: FolderRequestDTO)
  case fetchFolderList(start: Int, count: Int)
  case fetchBookmarkListInFolder(id: Int)
  case updateFolder(id: Int, request: FolderRequestDTO)
  case deleteFolder(id: Int)
}

extension FolderEndpoint {
  var baseRouthPath: String {
    return "/app/folders"
  }

  var fullPath: String {
    switch self {
    case .createFolder, .fetchFolderList:
      return AppProperties.baseURL + baseRouthPath
    case .fetchBookmarkListInFolder(let id):
      return AppProperties.baseURL + baseRouthPath + "/\(id)/bookmarks"
    case .deleteFolder(let id), .updateFolder(let id, _):
      return AppProperties.baseURL + baseRouthPath + "\(id)"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .createFolder:
      return .post
    case .fetchFolderList, .fetchBookmarkListInFolder:
      return .get
    case .updateFolder:
      return .patch
    case .deleteFolder:
      return .delete
    }
  }

  var parameters: [String : String]? {
    switch self {
    case .fetchFolderList(let start, let count):
      return ["page": "\(start)", "size": "\(count)"]

    case .createFolder(let request):
      return [
        "title": request.title,
        "color": request.color,
      ]

    case .updateFolder(_, let request):
      return [
        "folderName": request.title,
        "label": request.color
      ]

    case .deleteFolder, .fetchBookmarkListInFolder:
      return nil
    }
  }
}
