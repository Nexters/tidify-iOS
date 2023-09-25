//
//  UIView+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public extension UIView {
  func addTap() -> UITapGestureRecognizer {
    let tapGestureRecognizer: UITapGestureRecognizer = .init()
    addGestureRecognizer(tapGestureRecognizer)

    return tapGestureRecognizer
  }

  func cornerRadius(_ corners: [UIRectCorner] = [.allCorners], radius: CGFloat) {
    layer.masksToBounds = true
    layer.cornerCurve = .continuous
    layer.cornerRadius = radius

    if corners != [.allCorners] {
      var cornerMask: CACornerMask = .init()

      corners.forEach {
        if $0 == .topLeft {
          cornerMask.insert(.layerMinXMinYCorner)
        }
        if $0 == .topRight {
          cornerMask.insert(.layerMaxXMinYCorner)
        }
        if $0 == .bottomLeft {
          cornerMask.insert(.layerMinXMaxYCorner)
        }
        if $0 == .bottomRight {
          cornerMask.insert(.layerMaxXMaxYCorner)
        }
      }

      layer.maskedCorners = cornerMask
    }
  }
}
