//
//  UIImage+.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/05/20.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

extension UIImage {
  static var symbolImage: UIImage {
    return .init(named: "icon_symbol")!
  }

  func isSame(with image: UIImage) -> Bool {
    guard let currentImageData = self.pngData() as? NSData, let imageData = image.pngData() else {
      return false
    }

    return currentImageData.isEqual(to: imageData)
  }
}
