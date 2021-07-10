//
//  BookMarkAPI.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import Moya

enum BookMarkAPI {
    case getBookMarkList(_ id: String)
    case createBookMark
}

extension BookMarkAPI: TargetType {
    var baseURL: URL {
        return URL(string: Environment.shared.baseURL)!
    }

    var path: String {
        switch self {
        case .getBookMarkList, .createBookMark:
            return "bookmarks"
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

        return . requestParameters(parameters: requestParameters, encoding: encoding)
    }

    var headers: [String: String]? {
        return nil
    }

    private var parameters: [String: Any]? {
        switch self {
        case let .getBookMarkList(id):
            return ["tmp_id": id]
        case .createBookMark:
            return nil
        }
    }
}
