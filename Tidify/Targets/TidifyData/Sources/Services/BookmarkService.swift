//
//  BookmarkService.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

import Moya
import TidifyCore

enum BookmarkService {
  case fetchBookmarkList(id: Int)
  case createBookmark(url: String, title: String?, folder: String?)
}

extension BookmarkService: TargetType {
  var baseURL: URL {
    return .init(string: AppProperties.baseURL)!
  }

  var path: String {
    let baseRoutePath: String = "/api/v1/bookmarks"

    switch self {
    case .fetchBookmarkList, .createBookmark:
      return baseRoutePath
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchBookmarkList:
      return .get
    case .createBookmark:
      return .post
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    let requestParams: [String: Any] = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put:
      encoding = JSONEncoding.default
    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParams, encoding: encoding)
  }

  var headers: [String : String]? {
    if let authorization = AppProperties.authorization {
      return ["tidify-auth": authorization]
    }

    return nil
  }

  private var parameters: [String: Any]? {
    switch self {
//    case let .createBookmark(url, title, ogImageURL, tags):
//      return [
//        "url": url,
//        "title": title ?? "",
//        "og_img_url": ogImageURL ?? "",
//        "tags": tags ?? ""
//      ]
    case let .createBookmark(url, title, folder):
      return [
        "url": url,
        "title": title ?? "",
        "folder": folder ?? ""
      ]

    case .fetchBookmarkList:
      return nil
    }
  }
}
