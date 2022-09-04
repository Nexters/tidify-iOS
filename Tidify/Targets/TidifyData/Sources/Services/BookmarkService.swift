//
//  BookmarkService.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation
import TidifyCore
import TidifyDomain

import Moya

enum BookmarkService {
  case fetchBookmarkList
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
    case .fetchBookmarkList, .createBookmark, .deleteBookmark, .updateBookmark:
      return baseRoutePath
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
      return .put
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
    if let authorization = AppProperties.accessToken {
      return ["tidify-auth": authorization]
    }

    return nil
  }

  private var parameters: [String: Any]? {
    switch self {
    case .fetchBookmarkList:
      return nil

    case .createBookmark(let requestDTO):
      return [
        "folder_id": requestDTO.folderID,
        "bookmark_url": requestDTO.url,
        "bookmark_title": requestDTO.title
      ]

    case .deleteBookmark(let bookmarkID):
      return [
        "bookmark_id": bookmarkID
      ]

    case let .updateBookmark(bookmarkID, requestDTO):
      return [
        "bookmark_id": bookmarkID,
        "folder_id": requestDTO.folderID,
        "bookmark_url": requestDTO.url,
        "bookmark_title": requestDTO.title
      ]
    }
  }
}
