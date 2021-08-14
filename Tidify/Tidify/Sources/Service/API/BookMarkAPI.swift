//
//  BookMarkAPI.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import Moya

enum BookMarkAPI {
    case getBookMarkList(id: Int)
    case createBookMark(title: String, url: String)
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
        return ["tidify-auth": Environment.shared.authorization]
    }

    private var parameters: [String: Any]? {
        switch self {
        case let .createBookMark(title, url):
            return ["title": title, "url": url]
        case .getBookMarkList:
            return nil
        }
    }
}
