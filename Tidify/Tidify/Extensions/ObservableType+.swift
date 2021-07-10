//
//  ObservableType+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

extension ObservableType where Element == Response {
    func t_map<D: Decodable>(_ type: D.Type,
                             atKeyPath keyPath: String? = nil,
                             using decoder: JSONDecoder = JSONDecoder(),
                             failsOnEmptyData: Bool = true) -> Observable<D> {
        return flatMap { response -> Observable<D> in
            do {
                let object = try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                return Observable.just(object)
            } catch {
                print("[ERROR] PARSE ERROR: \(D.self)")
                throw error
            }
        }
    }
}
