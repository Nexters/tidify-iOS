//
//  SharedSequenceConvertibleType+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/19.
//

import Foundation
import RxSwift
import RxCocoa

extension SharedSequenceConvertibleType {
    func t_unwrap<T>() -> SharedSequence<SharingStrategy, T> where Element == T? {
        return self.compactMap { $0 } 
    }
}
