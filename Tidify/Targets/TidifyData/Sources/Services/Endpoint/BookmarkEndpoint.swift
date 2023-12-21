//
//  BookmarkEndpoint.swift
//  TidifyData
//
//  Created by 여정수 on 2023/07/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

enum BookmarkEndpoint: EndpointType {
  case fetchBoomarkList(request: BookmarkListRequest, category: BookmarkCategory)
  case createBookmark(request: BookmarkRequestDTO)
  case deleteBookmark(ID: Int)
  case updateBookmark(ID: Int, request: BookmarkRequestDTO)
  case favoriteBookmark(ID: Int)
}

extension BookmarkEndpoint {
  var baseRouthPath: String {
    return "/app/bookmarks"
  }

  var fullPath: String {
    switch self {
    case .fetchBoomarkList(let request, let category):
      if request.keyword.isNotNil {
        return AppProperties.baseURL + baseRouthPath + "/search"
      }
      return AppProperties.baseURL + (category == .normal ? baseRouthPath : baseRouthPath + "/star")
    case .createBookmark:
      return AppProperties.baseURL + baseRouthPath
    case .deleteBookmark(let id), .updateBookmark(let id, _):
      return AppProperties.baseURL + baseRouthPath + "/\(id)"
    case .favoriteBookmark(let id):
      return AppProperties.baseURL + baseRouthPath + "/star/\(id)"
    }
  }

  var method: HTTPMethod {
    switch self {
    case .fetchBoomarkList:
      return .get
    case .createBookmark, .favoriteBookmark:
      return .post
    case .deleteBookmark:
      return .delete
    case .updateBookmark:
      return .patch
    }
  }

  var parameters: [String : String]? {
    switch self {
    case .fetchBoomarkList(let request, _):
      var params: [String: String] = [
        "size": "\(request.size)",
        "page": "\(request.page)"
      ]

      if let keyword = request.keyword {
        params["keyword"] = keyword
      }
      return params

    case .createBookmark(let request):
      return [
        "name": request.name,
        "url": request.url,
        "folderId": "\(request.folderID)"
      ]

    case .updateBookmark(_, let request):
      return [
        "folderId": "\(request.folderID)",
        "url": request.url,
        "name": request.name
      ]

    case .deleteBookmark, .favoriteBookmark:
      return nil
    }
  }
}
