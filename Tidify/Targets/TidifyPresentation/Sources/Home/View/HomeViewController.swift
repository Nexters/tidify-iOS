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
  private lazy var tableView: TidifyTableView = .init(tabType: .bookmark)

  private let alertPresenter: AlertPresenter
  private let deleteBookmarkSubject: PublishSubject<Int> = .init()

  var disposeBag: DisposeBag = .init()

  // MARK: - Initializer
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

    tableView.delegate = self

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
      $0.textColor = .secondaryLabel
      $0.font = .systemFont(ofSize: 16, weight: .bold)
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
      $0.bottom.equalToSuperview().inset(Self.viewHeight * 0.142)
    }

    guideView.snp.makeConstraints {
      $0.edges.equalTo(containerView)
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
      .map { Action.fetchBookmarks(isInitialRequest: true) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    Observable.merge(rx.viewDidAppear, UIApplication.rx.willEnterForeground.asObservable())
      .map(fetchSharedBookmark)
      .filter { !$0.url.isEmpty && !$0.title.isEmpty }
      .map { Action.didFetchSharedBookmark(url: $0.url, title: $0.url) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(Bookmark.self)
      .map { Action.didSelect($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.deleteAction
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, index in
        owner.presentDeleteBookmarkAlert(deleteTargetRow: index)
      })
      .disposed(by: disposeBag)

    tableView.editAction
      .map { Action.editBookmark($0) }
      .bind(to: reactor.action)
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
        cellType: BookmarkCell.self)) { _, model, cell in
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

extension HomeViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    guard let bookmarksCount = reactor?.currentState.bookmarks.count else {
      return
    }

    if indexPath.row >= bookmarksCount - 5 {
      reactor?.action.onNext(.fetchBookmarks())
    }
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

  func fetchSharedBookmark() -> (url: String, title: String) {
    var sharedData: (url: String, title: String) = ("", "")

    guard let userDefault: UserDefaults = .init(suiteName: "group.com.ian.Tidify.share") else {
      return sharedData
    }

    if let url = userDefault.string(forKey: "SharedURL"),
       let text = userDefault.string(forKey: "SharedText") {
      sharedData = (url, text)
      userDefault.removeObject(forKey: "SharedURL")
      userDefault.removeObject(forKey: "SharedText")
    }

    return sharedData
  }
}
