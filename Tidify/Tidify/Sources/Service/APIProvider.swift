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

enum ApiProvider {
    private static let moyaProvider = MoyaProvider<MultiTarget>()

    static func request(_ target: TargetType,
                        callBackQueue: DispatchQueue? = nil) -> Single<Response> {
        return moyaProvider.rx.request(MultiTarget(target), callbackQueue: callBackQueue)
            .filterSuccessfulStatusCodes()
    }
}
