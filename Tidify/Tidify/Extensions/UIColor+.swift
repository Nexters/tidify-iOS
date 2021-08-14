//
//  UIColor+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

public extension UIColor {
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    static func t_tidiBlue() -> UIColor {
        return .init(28, 100, 234)
    }

    static func t_indigoBlue() -> UIColor {
        return .init(80, 78, 210)
    }
}
