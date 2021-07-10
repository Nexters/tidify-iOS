//
//  ObservableConvertibleType+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

extension ObservableConvertibleType {
    func t_asDriverSkipError() -> Driver<Element> {
        return asDriver(onErrorDriveWith: .empty())
    }
}
