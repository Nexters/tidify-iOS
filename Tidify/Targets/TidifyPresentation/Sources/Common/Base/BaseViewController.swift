//
//  BaseViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/08/29.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import UIKit

class BaseViewController<T: ViewModelType, U: Coordinator>: UIViewController {

  // MARK: Properties
  let viewModel: T
  let coordinator: U
  var cancellable: Set<AnyCancellable> = []

  // MARK: Initializer
  init(viewModel: T, coordinator: U) {
    self.viewModel = viewModel
    self.coordinator = coordinator
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
