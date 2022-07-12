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

    setupViews()
    setupLayoutConstraints()
    bindOutput()
      .disposed(by: disposeBag)
  }

  // MARK: - Methods

  func setupViews() {
    // Override Layout
    view.backgroundColor = .t_background()
  }

  func setupLayoutConstraints() {
    // Override Constraints
  }

  func bindOutput() -> Disposable {
    // Bind ViewModel's Output
    return Disposables.create()
  }

  deinit {
    disposeBag = DisposeBag()
  }
}
