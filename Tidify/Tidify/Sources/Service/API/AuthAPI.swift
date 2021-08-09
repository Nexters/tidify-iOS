//
//  AuthAPI.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/09.
//

import Foundation
import Moya

enum SocialLoginType: String {
    case kakao = "kakao"
    case apple = "apple"
}

enum AuthAPI {
    case auth(socialLoginType: SocialLoginType, accessToken: String)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Environment.shared.baseURL)!
    }

    var path: String {
        let baseRoutePath = "/api/v1/auth"

        switch self {
        case .auth:
            return baseRoutePath
        }
    }

    var method: Moya.Method {
        switch self {
        case .auth:
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

    var headers: [String : String]? {
        return nil
    }

    private var parameters: [String: Any]? {
        switch self {
        case let .auth(socialLoginType, accessToken):
            return ["sns_type": socialLoginType.rawValue,
                    "access_token": accessToken]
        }
    }
}
