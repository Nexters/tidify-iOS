//
//  UIFont+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

public extension UIFont {

    /// Sugar for Regular Font
    static func t_R(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size)
    }

    /// Sugar for Bold Font
    static func t_B(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .bold)
    }


    /// Sugar for SemiBold Font
    static func t_SB(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .semibold)
    }

    /// Sugar for ExtraBold Font
    static func t_EB(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: size, weight: .heavy)
    }
}
