//
//  UIColor+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public extension UIColor {
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
    self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
  }

  convenience init(hex: String) {
    var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    
    if hexFormatted.hasPrefix("#") {
      hexFormatted = String(hexFormatted.dropFirst())
    }
    
    var color: UInt64 = 0
    Scanner(string: hexFormatted).scanHexInt64(&color)
    
    let red = CGFloat((color & 0xFF0000) >> 16) / 255.0
    let green = CGFloat((color & 0x00FF00) >> 8) / 255.0
    let blue = CGFloat(color & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: 1)
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
  
  static func t_borderColor() -> UIColor {
    return .init(60, 60, 67, 0.08)
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
