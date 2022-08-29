//
//  BookmarkCreationViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import ReactorKit

final class BookmarkCreationViewController: UIViewController, View {

  // MARK: - Properties
  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: BookmarkCreationReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension BookmarkCreationViewController {
  func bindAction(reactor: BookmarkCreationReactor) {

  }

  func bindState(reactor: BookmarkCreationReactor) {

  }

  func setupUI() {
    title = "북마크 생성"
    view.backgroundColor = .white
  }
}
