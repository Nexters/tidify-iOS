//
//  BaseViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/08/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

class BaseViewController<T>: UIViewController {

  // MARK: Properties
  var viewModel: T
  var cancellable: Set<AnyCancellable> = []

  // MARK: Initializer
  init(viewModel: T) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
    setupLayoutConstraints()
    bindState()
  }

  // MARK: Methods
  func setupViews() {
    view.backgroundColor = .white
  }

  func setupLayoutConstraints() {}
  func bindState() {}
}
