//
//  RxSwift+Moya.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
    func t_map<D: Decodable>(_ type: D.Type,
                             atKeyPath keyPath: String? = nil,
                             using decoder: JSONDecoder = JSONDecoder(),
                             failsOnEmptyData: Bool = true) -> PrimitiveSequence<Trait, D> {
        return flatMap { response in
            do {
                let object = try response.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                return .just(object)
            } catch {
                print("[ERROR] parse error: \(D.self)")
                throw error
            }
        }
    }
}
