//
//  Optional+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation

public extension Optional {
    var t_isNil: Bool {
        return self == nil
    }

    var t_isNotNil: Bool {
        return self != nil
    }
}

public extension Optional where Wrapped == String {
    var t_unwrap: String {
        return self ?? ""
    }
}

public extension Optional where Wrapped == Int {
    var t_unwrap: Int {
        return self ?? 0
    }
}

