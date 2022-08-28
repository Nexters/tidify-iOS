//
//  SettingViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

import ReactorKit

final class SettingViewController: UIViewController, View {

  // MARK: - Properties
  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: SettingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension SettingViewController {
  func bindAction(reactor: SettingReactor) {
    // TODO: Implementation
  }

  func bindState(reactor: SettingReactor) {
    // TODO: Implementation
  }

  func setupUI() {
    view.backgroundColor = .white
  }
}
