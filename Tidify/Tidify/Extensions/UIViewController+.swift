//
//  UIViewController+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/07.
//

import Foundation
import UIKit

public extension UIViewController {
    enum NavigationBarButtonDirection {
        case left
        case right
    }

    func t_setupNavigationBarButton(directionType: NavigationBarButtonDirection, button: UIButton) {
        let barButtonItem = UIBarButtonItem(customView: button)

        switch directionType {
        case .left:
            navigationItem.leftBarButtonItem = barButtonItem
        case .right:
            navigationItem.rightBarButtonItem = barButtonItem
        }
    }
}
