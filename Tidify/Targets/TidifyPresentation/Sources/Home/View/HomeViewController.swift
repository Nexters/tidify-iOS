//
//  HomeViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

import RxCocoa
import ReactorKit
import SnapKit
import Then


final class HomeViewController: UIViewController, View {

  // MARK: - Properties
  private lazy var guideView: UIView = .init()
  private lazy var guideLabel: UILabel = .init()
  private lazy var tableView: UITableView = .init()

  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension HomeViewController {
  func setupUI() {
    view.addSubview(guideView)
    guideView.addSubview(guideLabel)
    view.addSubview(tableView)

    guideView.do {
      $0.backgroundColor = .white
    }

    guideLabel.do {
      $0.text = "링크를 모아서 북마크로 만들어봐요!"
      $0.textColor = .t_indigo02()
    }

    tableView.do {
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: BookmarkCell.self)
      $0.rowHeight = UIScreen.main.bounds.height * 0.07
      $0.rx.setDelegate(self).disposed(by: disposeBag)
    }

    tableView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    guideView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func bindAction(reactor: HomeReactor) {
    typealias Action = HomeReactor.Action

    rx.viewWillAppear
      .startWith(())
      .map { Action.viewWillAppear(id: 0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.bookmarks }
      .bind(to: tableView.rx.items(
        cellIdentifier: "\(BookmarkCell.self)",
        cellType: BookmarkCell.self)) { idx, model, cell in
        cell.configure(bookmark: model)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {}
