//
//  UIView+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

public extension UIView {
    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    var top: CGFloat {
        return frame.origin.y
    }

    var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }

    var left: CGFloat {
        return frame.origin.x
    }

    var right: CGFloat {
        return frame.origin.x + frame.size.width
    }

    func t_addTap() -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        addGestureRecognizer(tapGestureRecognizer)

        return tapGestureRecognizer
    }

    func t_cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = radius

        if corners != [.allCorners] {
            var cornerMask = CACornerMask()

            corners.forEach {
                if $0 == .topLeft {
                    cornerMask.insert(CACornerMask.layerMinXMinYCorner)
                }
                if $0 == .topRight {
                    cornerMask.insert(CACornerMask.layerMaxXMinYCorner)
                }
                if $0 == .bottomLeft {
                    cornerMask.insert(CACornerMask.layerMinXMaxYCorner)
                }
                if $0 == .bottomRight {
                    cornerMask.insert(CACornerMask.layerMaxXMaxYCorner)
                }
            }

            layer.maskedCorners = cornerMask
        }
    }
}
