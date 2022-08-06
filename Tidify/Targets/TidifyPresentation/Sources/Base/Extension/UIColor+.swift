//
//  UIColor+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

// MARK: UIColor Extension
public extension UIColor {
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
    self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
  }

  convenience init?(hex: String) {
    let r, g, b: CGFloat

    if hex.hasPrefix("#") {
      let start = hex.index(hex.startIndex, offsetBy: 1)
      let hexColor = String(hex[start...])

      if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff0000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff) >> 8) / 255
          self.init(red: r, green: g, blue: b, alpha: 1)
          return
        }
      }
    }

    return nil
  }

  static func t_tidiBlue00() -> UIColor {
    return .init(28, 100, 234)
  }

  static func t_tidiBlue01() -> UIColor {
    return .init(55, 154, 240)
  }

  static func t_tidiBlue02() -> UIColor {
    return .init(84, 200, 245)
  }

  static func t_indigo00() -> UIColor {
    return .init(80, 78, 210)
  }

  static func t_indigo01() -> UIColor {
    return .init(105, 103, 215)
  }

  static func t_indigo02() -> UIColor {
    return .init(137, 152, 233)
  }

  static func t_background() -> UIColor {
    return .init(235, 235, 240)
  }

  func toHexString() -> String {
    var r:CGFloat = 0
    var g:CGFloat = 0
    var b:CGFloat = 0
    var a:CGFloat = 0
    getRed(&r, green: &g, blue: &b, alpha: &a)
    let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    return String(format:"#%06x", rgb)
  }
}
