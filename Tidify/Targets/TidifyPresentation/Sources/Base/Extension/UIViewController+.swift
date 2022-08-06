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

public extension Reactive where Base: UIViewController {
  var viewDidLoad: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewDidLoad))
      .mapToVoid()
  }

  var viewWillAppear: Observable<Void> {
    self.methodInvoked(#selector(UIViewController.viewWillAppear(_:)))
      .mapToVoid()
  }

  var vieDidAppear: Observable<Void> {
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
