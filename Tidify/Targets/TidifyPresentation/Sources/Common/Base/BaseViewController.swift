//
//  BaseViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/08/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import UIKit

class BaseViewController: UIViewController {

  // MARK: Properties
  var cancellable: Set<AnyCancellable> = []

  lazy var indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_blue()
    return indicatorView
  }()

  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  // MARK: Methods
  func setupViews() {
    view.backgroundColor = .t_background()
  }

  func setIndicatorView(isLoading: Bool) {
    if isLoading {
      indicatorView.startAnimating()
    } else {
      indicatorView.isHidden = true
    }
  }
}
