//
//  UIAlertAction+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/13.
//

import Foundation
import UIKit

extension UIAlertAction {
    var titleTextColor: UIColor? {
        get {
            self.value(forKey: "titleTextColor") as? UIColor
        }
        set {
            self.setValue(newValue, forKey: "titleTextColor")
        }
    }
}
