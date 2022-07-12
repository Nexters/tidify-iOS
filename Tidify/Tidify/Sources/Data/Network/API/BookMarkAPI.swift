//
//  BookMarkAPI.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Moya

enum BookMarkAPI {
  case getBookMarkList(id: Int)
  case createBookMark(url: String, title: String?, ogImageUrl: String?, tags: String?)
}

extension BookMarkAPI: TargetType {
  var baseURL: URL {
    return URL(string: Environment.shared.baseURL)!
  }

  var path: String {
    let baseRoutePath = "/api/v1/bookmarks"

    switch self {
    case .getBookMarkList, .createBookMark:
      return baseRoutePath
    }
  }

  var method: Moya.Method {
    switch self {
    case .getBookMarkList:
      return .get
    case .createBookMark:
      return .post
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    let requestParameters = parameters ?? [:]
    let encoding: ParameterEncoding

    switch self.method {
    case .post, .patch, .put:
      encoding = JSONEncoding.default
    default:
      encoding = URLEncoding.default
    }

    return .requestParameters(parameters: requestParameters, encoding: encoding)
  }

  var headers: [String: String]? {
    if let authorization = Environment.shared.authorization {
      return ["tidify-auth": authorization]
    }
    return nil
  }

  private var parameters: [String: Any]? {
    switch self {
    case let .createBookMark(url, title, ogImageUrl, tags):
      return ["url": url,
              "title": title ?? "",
              "og_img_url": ogImageUrl ?? "",
              "tags": tags ?? ""]
    case .getBookMarkList:
      return nil
    }
  }
}
