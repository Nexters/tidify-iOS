//
//  HomeViewController.swift
//  TidifyPresentation
//
//  Created by ian on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

import RxCocoa
import ReactorKit
import SnapKit
import Then

final class HomeViewController: UIViewController, View {

  // MARK: - Properties
  private let navigationBar: TidifyNavigationBar!
  private let containerView: UIView = .init()
  private lazy var guideView: UIView = .init()
  private lazy var guideLabel: UILabel = .init()
  private lazy var tableView: UITableView = .init()

  private let alertPresenter: AlertPresenter
  private let deleteBookmarkSubject: PublishSubject<Int> = .init()

  var disposeBag: DisposeBag = .init()

  // MARK: - Constructor
  init(with navigationBar: TidifyNavigationBar, alertPresenter: AlertPresenter) {
    self.navigationBar = navigationBar
    self.alertPresenter = alertPresenter

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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
    view.addSubview(navigationBar)
    view.addSubview(containerView)
    containerView.addSubview(guideView)
    containerView.addSubview(tableView)
    guideView.addSubview(guideLabel)

    view.backgroundColor = .t_background()

    containerView.do {
      $0.cornerRadius([.topLeft, .topRight], radius: 16)
      $0.backgroundColor = .white
    }

    guideView.do {
      $0.backgroundColor = .white
    }

    guideLabel.do {
      $0.text = "링크를 모아서 북마크로 만들어봐요!"
      $0.textColor = .t_indigo02()
      $0.font = .systemFont(ofSize: 16, weight: .bold)
    }

    tableView.do {
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: BookmarkCell.self)
      $0.rowHeight = UIScreen.main.bounds.height * 0.07
      $0.rx.setDelegate(self).disposed(by: disposeBag)
    }

    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.182)
    }

    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview()
    }

    guideView.snp.makeConstraints {
      $0.edges.equalTo(tableView)
    }

    guideLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.height.equalTo(20)
      $0.centerX.equalToSuperview()
    }
  }

  func bindAction(reactor: HomeReactor) {
    typealias Action = HomeReactor.Action

    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(Bookmark.self)
      .map { Action.didSelect($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.rx.itemDeleted
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { owner, indexPath in
        owner.presentDeleteBookmarkAlert(deleteTargetRow: indexPath.row)
      })
      .disposed(by: disposeBag)

    deleteBookmarkSubject
      .withLatestFrom(reactor.state.map { $0.bookmarks }) { ($0, $1) }
      .map { index, bookmarks in
        Action.didDelete(bookmarks[index])
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.bookmarks }
      .distinctUntilChanged()
      .bind(to: tableView.rx.items(
        cellIdentifier: "\(BookmarkCell.self)",
        cellType: BookmarkCell.self)) { idx, model, cell in
          cell.configure(bookmark: model)
        }
        .disposed(by: disposeBag)

    reactor.state
      .map { $0.didPushWebView }
      .subscribe()
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.bookmarks.isEmpty }
      .bind(to: tableView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}

// MARK: - Private Extension
private extension HomeViewController {
  func presentDeleteBookmarkAlert(deleteTargetRow: Int) {
    let rightButtonAction: ButtonAction = { [weak self] in
      self?.deleteBookmarkSubject.onNext(deleteTargetRow)
    }

    alertPresenter.present(
      on: self,
      alertType: .deleteBookmark,
      rightButtonAction: rightButtonAction
    )
  }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {}
