//
//  UIFont+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

// MARK: UIFont Extension
public extension UIFont {
  static func t_R(_ size: CGFloat) -> UIFont {
    systemFont(ofSize: size)
  }

  static func t_B(_ size: CGFloat) -> UIFont {
    systemFont(ofSize: size, weight: .bold)
  }

  static func t_SB(_ size: CGFloat) -> UIFont {
    systemFont(ofSize: size, weight: .semibold)
  }

  static func t_EB(_ size: CGFloat) -> UIFont {
    systemFont(ofSize: size, weight: .heavy)
  }
}
