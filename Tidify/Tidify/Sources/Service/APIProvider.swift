//
//  APIProvider.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

class ApiProvider {
    static func request(_ target: TargetType,
                        callbackQueue: DispatchQueue? = .none,
                        progress: ProgressBlock? = .none,
                        completion: @escaping Completion) -> Cancelable {
        return request(target, completion: completion)
    }

    private init() { }
}
