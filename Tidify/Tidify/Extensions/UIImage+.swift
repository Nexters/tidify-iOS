//
//  UIImage+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/15.
//

import Foundation
import UIKit

public extension UIImage {
    func resize(newWidth: CGFloat, fixedHeight: CGFloat?) -> UIImage {
        let newHeight: CGFloat
        let scale = newWidth / self.size.width

        if let fixedHeight = fixedHeight {
            newHeight = fixedHeight
        } else {
            newHeight = self.size.height * scale
        }

        let size = CGSize(w: newWidth, h: newHeight)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }

        return renderImage
    }
}
