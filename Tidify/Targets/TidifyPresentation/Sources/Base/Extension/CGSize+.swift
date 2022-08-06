//
//  CGSize+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

// MARK: CGSize Extension
public extension CGSize {
  init(w: CGFloat, h: CGFloat) {
    self.init(width: w, height: h)
  }

  init(w: Int, h: Int) {
    self.init(width: w, height: h)
  }

  init(w: Double, h: Double) {
    self.init(width: w, height: h)
  }
}
