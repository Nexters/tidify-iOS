//
//  UIColor+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public extension UIColor {

  // MARK: Properties
  enum LabelColors: String {
    case SKYBLUE = "SKYBLUE"
    case BLUE = "BLUE"
    case PURPLE = "PURPLE"
    case GREEN = "GREEN"
    case YELLOW = "YELLOW"
    case ORANGE = "ORANGE"
    case RED = "RED"
    case BLACK = "BLACK"

    var colorString: String {
      return rawValue
    }
  }

  // MARK: Initializer
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
    self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
  }

  // MARK: Methods
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

  static func toColor(_ colorString: String) -> UIColor {
    switch colorString {
    case LabelColors.SKYBLUE.colorString: return .t_tidiBlue01()
    case LabelColors.BLUE.colorString: return .t_tidiBlue00()
    case LabelColors.PURPLE.colorString: return .t_indigo00()
    case LabelColors.GREEN.colorString: return .systemGreen
    case LabelColors.YELLOW.colorString: return .systemYellow
    case LabelColors.ORANGE.colorString: return .systemOrange
    case LabelColors.RED.colorString: return .systemRed
    case LabelColors.BLACK.colorString: return .black
    default: return .init()
    }
  }

  func toColorString() -> String {
    switch self {
    case .t_tidiBlue01(): return LabelColors.SKYBLUE.colorString
    case .t_tidiBlue00(): return LabelColors.BLUE.colorString
    case .t_indigo00(): return LabelColors.PURPLE.colorString
    case .systemGreen: return LabelColors.GREEN.colorString
    case .systemYellow: return LabelColors.YELLOW.colorString
    case .systemOrange: return LabelColors.ORANGE.colorString
    case .systemRed: return LabelColors.RED.colorString
    case .black: return LabelColors.BLACK.colorString
    default: return ""
    }
  }
}
