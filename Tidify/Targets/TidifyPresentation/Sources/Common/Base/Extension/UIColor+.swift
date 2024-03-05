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
  enum LabelColors {
    case ASHBLUE
    case BLUE
    case PURPLE
    case GREEN
    case YELLOW
    case ORANGE
    case RED
    case INDIGO
    case MINT
    case PINK

    var colorString: String {
      switch self {
      case .ASHBLUE: return "ASHBLUE"
      case .BLUE: return "BLUE"
      case .PURPLE: return "PURPLE"
      case .GREEN: return "GREEN"
      case .YELLOW: return "YELLOW"
      case .ORANGE: return "ORANGE"
      case .RED: return "RED"
      case .MINT: return "MINT"
      case .INDIGO: return "INDIGO"
      case .PINK: return "PINK"
      }
    }
  }

  // MARK: Initializer
  convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
    self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
  }

  // MARK: Methods
  static func t_background() -> UIColor {
    return .init(244, 245, 246)
  }

  static func t_pink() -> UIColor {
    return .init(255, 45, 85)
  }

  static func t_red() -> UIColor {
    return .init(255, 59, 48)
  }

  static func t_orange() -> UIColor {
    return .init(255, 149, 0)
  }

  static func t_yellow() -> UIColor {
    return .init(255, 204, 0)
  }

  static func t_green() -> UIColor {
    return .init(52, 199, 89)
  }

  static func t_mint() -> UIColor {
    return .init(0, 199, 190)
  }

  static func t_purple() -> UIColor {
    return .init(175, 82, 222)
  }

  static func t_indigo() -> UIColor {
    return .init(80, 78, 210)
  }

  static func t_blue() -> UIColor {
    return .init(28, 100, 234)
  }

  static func t_ashBlue(weight: Int = 500) -> UIColor {
    switch weight {
    case 50: return .init(251, 252, 254)
    case 100: return .init(231, 237, 243)
    case 300: return .init(174, 195, 213)
    case 500: return .init(103, 142, 177)
    case 800: return .init(42, 62, 81)
    default: return .init()
    }
  }

  static func t_gray(weight: Int) -> UIColor {
    switch weight {
    case 50: return .init(244, 245, 246)
    case 100: return .init(224, 227, 230)
    case 400: return .init(162, 170, 180)
    case 500: return .init(139, 149, 161)
    case 600: return .init(110, 121, 135)
    case 700: return .init(87, 96, 107)
    case 800: return .init(57, 63, 70)
    default: return .init()
    }
  }

  static func toColor(_ colorString: String) -> UIColor {
    switch colorString {
    case LabelColors.ASHBLUE.colorString, "BLACK": return .t_ashBlue()
    case LabelColors.BLUE.colorString: return .t_blue()
    case LabelColors.PURPLE.colorString: return .t_purple()
    case LabelColors.GREEN.colorString: return .t_green()
    case LabelColors.YELLOW.colorString: return .t_yellow()
    case LabelColors.ORANGE.colorString: return .t_orange()
    case LabelColors.RED.colorString: return .t_red()
    case LabelColors.MINT.colorString, "SKYBLUE": return .t_mint()
    case LabelColors.INDIGO.colorString: return t_indigo()
    case LabelColors.PINK.colorString: return .t_pink()
    default: return .t_ashBlue()
    }
  }

  func toColorString() -> String {
    switch self {
    case .t_ashBlue(): return LabelColors.ASHBLUE.colorString
    case .t_blue(): return LabelColors.BLUE.colorString
    case .t_purple(): return LabelColors.PURPLE.colorString
    case .t_green(): return LabelColors.GREEN.colorString
    case .t_yellow(): return LabelColors.YELLOW.colorString
    case .t_orange(): return LabelColors.ORANGE.colorString
    case .t_red(): return LabelColors.RED.colorString
    case .t_indigo(): return LabelColors.INDIGO.colorString
    case .t_pink(): return LabelColors.PINK.colorString
    case .t_mint(): return LabelColors.MINT.colorString
    default: return ""
    }
  }
}
