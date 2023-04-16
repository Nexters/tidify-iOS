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
  case fetchBookmarkList(start: Int = 0, count: Int = 10, folderID: Int = 0, keyword: String? = nil)
  case createBookmark(_ requestDTO: BookmarkRequestDTO)
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
    case .fetchBookmarkList, .createBookmark, .deleteBookmark:
      return baseRoutePath

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
    case let .fetchBookmarkList(start, count, folderID, keyword):
      if let keyword = keyword {
        return [
          "start": start,
          "count": count,
          "folder": folderID,
          "keyword": keyword
        ]
      }
      return [
        "start": start,
        "count": count,
        "folder": folderID,
      ]

    case .createBookmark(let requestDTO):
      return [
        "folder_id": requestDTO.folderID,
        "bookmark_url": requestDTO.url,
        "bookmark_title": requestDTO.name
      ]

    case .deleteBookmark(let bookmarkID):
      return [
        "bookmark_id": bookmarkID
      ]

    case let .updateBookmark(_, requestDTO):
      return [
        "folderId": requestDTO.folderID,
        "url": requestDTO.url,
        "name": requestDTO.name
      ]
    }
  }
}
