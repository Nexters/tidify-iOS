//
//  Array+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation

public extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
