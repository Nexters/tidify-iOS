//
//  ObservableConvertibleType+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import Moya

extension ObservableConvertibleType {
    func t_asDriverSkipError() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}
