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
  case fetchFolderList(start: Int, count: Int, category: FolderCategory)
  case fetchBookmarkListInFolder(id: Int, subscribe: Bool)
  case updateFolder(id: Int, request: FolderRequestDTO)
  case deleteFolder(id: Int)
  case subscribeFolder(id: Int)
  case stopSubscription(id: Int)
  case stopSharingFolder(id: Int)
}

extension FolderEndpoint {
  var baseRoutePath: String {
    return "/app/folders"
  }

  var fullPath: String {
    switch self {
    case .createFolder:
      return AppProperties.baseURL + baseRoutePath
    case .fetchFolderList(_, _, let category):
      let path: String = AppProperties.baseURL + baseRoutePath

      switch category {
      case .normal: return path
      case .subscribe: return path + "/subscribed"
      case .share: return path + "/subscribing"
      }
    case .fetchBookmarkListInFolder(let id, let subscribe):
      var finalPath = AppProperties.baseURL + baseRoutePath + "/\(id)/bookmarks"
      if subscribe {
        finalPath += "/shared"
      }
      return finalPath
    case .deleteFolder(let id), .updateFolder(let id, _):
      return AppProperties.baseURL + baseRoutePath + "/\(id)"
    case .subscribeFolder(let id):
      return AppProperties.baseURL + baseRoutePath + "/subscribed/\(id)"
    case .stopSubscription(let id):
      return AppProperties.baseURL + baseRoutePath + "/un-subscribed/\(id)"
    case .stopSharingFolder(let id):
      return AppProperties.baseURL + baseRoutePath + "/\(id)/share-suspending"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .createFolder, .subscribeFolder, .stopSubscription, .stopSharingFolder:
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
    case .fetchFolderList(let start, let count, _):
      return ["page": "\(start)", "size": "\(count)"]

    case .createFolder(let request):
      return [
        "folderName": request.title,
        "label": request.color,
      ]

    case .updateFolder(_, let request):
      return [
        "folderName": request.title,
        "label": request.color
      ]

    default: return nil
    }
  }
}
