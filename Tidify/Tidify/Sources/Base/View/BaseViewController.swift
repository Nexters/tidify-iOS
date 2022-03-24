//
//  BaseViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import RxCocoa
import RxSwift
import SnapKit

import UIKit

class BaseViewController: UIViewController, BaseViewControllable {

  var disposeBag = DisposeBag()

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .t_background()

    setupViews()
    setupLayoutConstraints()
  }

  // MARK: - Methods

  func setupViews() {
    // Override Layout
  }

  func setupLayoutConstraints() {
    // Override Constraints
  }

  func bindOutput() {
    // Bind ViewModel's Output
  }

  deinit {
    disposeBag = DisposeBag()
  }
}
