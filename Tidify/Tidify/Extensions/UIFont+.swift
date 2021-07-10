//
//  UIFont+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

public extension UIFont {
    static func t_R(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size)
    }

    static func t_B(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .bold)
    }

    static func t_SB(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .semibold)
    }
}
