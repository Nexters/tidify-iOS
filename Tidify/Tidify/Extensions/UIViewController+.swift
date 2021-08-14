//
//  UIViewController+.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/07.
//

import Foundation
import RxSwift
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

// MARK: - UIViewController + Rx

public extension Reactive where Base: UIViewController {
    var viewDidLoad: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
    }

    var viewWillAppear: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
    }

    var viewDidAppear: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewDidAppear(_:))).map { _ in }
    }

    var viewDidDisappear: Observable<Void> {
        return self.methodInvoked(#selector(Base.viewDidDisappear(_:))).map { _ in }
    }
}
