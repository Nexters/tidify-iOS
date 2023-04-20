//
//  BookmarkService.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyDomain

import Moya

enum BookmarkService {
  case fetchBookmarkList(requestDTO: BookmarkListRequestDTO)
  case createBookmark(requestDTO: BookmarkRequestDTO)
  case deleteBookmark(bookmarkID: Int)
  case updateBookmark(bookmarkID: Int, requestDTO: BookmarkRequestDTO)
}

extension BookmarkService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    let baseRoutePath: String = "/bookmarks"

    switch self {
    case .fetchBookmarkList, .createBookmark:
      return baseRoutePath

    case .deleteBookmark(let bookmarkID):
      return baseRoutePath + "/\(bookmarkID)"

    case .updateBookmark(let bookmarkID, _):
      return baseRoutePath + "/\(bookmarkID)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchBookmarkList:
      return .get
    case .createBookmark:
      return .post
    case .deleteBookmark:
      return .delete
    case .updateBookmark:
      return .patch
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    let requestParams: [String: Any] = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put, .delete:
      encoding = JSONEncoding.default
    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParams, encoding: encoding)
  }

  var headers: [String : String]? {
    ["access-token": AppProperties.accessToken]
  }

  private var parameters: [String: Any]? {
    switch self {
    case let .fetchBookmarkList(request):
      var params: [String: Any] = [
        "size": request.size,
        "page": request.page
      ]

      if let keyword = request.keyword {
        params["keyword"] = keyword
      }

      return params

    case .createBookmark(let request):
      return [
        "folder_id": request.folderID,
        "bookmark_url": request.url,
        "bookmark_title": request.name
      ]

    case .deleteBookmark:
      return nil

    case let .updateBookmark(_, request):
      return [
        "folderId": request.folderID,
        "url": request.url,
        "name": request.name
      ]
    }
  }
}
