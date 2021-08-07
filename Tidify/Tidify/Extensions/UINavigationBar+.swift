//
//  UINavigationBar+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/07.
//

import Foundation
import UIKit

public extension UINavigationBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(w: UIScreen.main.bounds.width, h: 150)
    }
}
