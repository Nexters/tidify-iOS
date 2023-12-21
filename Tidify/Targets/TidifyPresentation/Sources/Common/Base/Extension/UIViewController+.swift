//
//  UIViewController+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

import RxCocoa
import RxSwift

public extension UIViewController {
  static var viewHeight: CGFloat {
    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return 0
    }
    return window.screen.bounds.height
  }

  static var viewWidth: CGFloat {
    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return 0
    }
    return window.screen.bounds.width
  }

  static var topPadding: CGFloat {
    guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
      return 0
    }
    return window.windows.first?.safeAreaInsets.top ?? 0
  }
}

public extension Reactive where Base: UIViewController {
  var viewDidLoad: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewDidLoad))
      .mapToVoid()
  }

  var viewWillAppear: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
      .mapToVoid()
  }

  var viewDidAppear: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewDidAppear(_:)))
      .mapToVoid()
  }

  var viewWillDisappear: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewWillDisappear(_:)))
      .mapToVoid()
  }

  var viewDidDisappear: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewDidDisappear(_:)))
      .mapToVoid()
  }
}
