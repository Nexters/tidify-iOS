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

final class HomeViewController: UIViewController, View, UIScrollViewDelegate {

  // MARK: - Properties
  private var navigationBar: TidifyNavigationBar!
  private let navSettingButton: UIButton = .init()
  private let navCreateBookmarkButton: UIButton = .init()
  private let containerView: UIView = .init()
  private lazy var guideView: UIView = .init()
  private lazy var guideLabel: UILabel = .init()
  private lazy var tableView: TidifyTableView = .init(tabType: .bookmark)

  private let alertPresenter: AlertPresenter
  private let deleteBookmarkSubject: PublishSubject<Int> = .init()

  private lazy var dataSource: UITableViewDiffableDataSource<Int, Bookmark> = {
    UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
      let cell = tableView.t_dequeueReusableCell(cellType: BookmarkCell.self, indexPath: indexPath)
      cell.configure(bookmark: item)
      return cell
    }
  }()

  var disposeBag: DisposeBag = .init()

  // MARK: - Initializer
  init(alertPresenter: AlertPresenter) {
    self.alertPresenter = alertPresenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()

    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    dataSource.apply(snapshot)
  }

  func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension HomeViewController {
  func setupUI() {
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
      $0.textColor = .secondaryLabel
      $0.font = .systemFont(ofSize: 16, weight: .bold)
    }

    navSettingButton.do {
      $0.setImage(.init(named: "profileIcon"), for: .normal)
      $0.frame = .init(
        x: 0,
        y: 0,
        width: UIViewController.viewHeight * 0.043, height: UIViewController.viewHeight * 0.049
      )
    }

    navCreateBookmarkButton.do {
      $0.setImage(.init(named: "createBookMarkIcon"), for: .normal)
      $0.frame = .init(
        x: 0,
        y: 0,
        width: UIViewController.viewWidth * 0.506,
        height: UIViewController.viewHeight * 0.049
      )
    }

    navigationBar = .init(.home, leftButton: navSettingButton, rightButton: navCreateBookmarkButton)
    view.addSubview(navigationBar)

    tableView.dataSource = dataSource
    tableView.prefetchDataSource = self

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
      .map { Action.didFetchSharedBookmark(url: $0.url, title: $0.title) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.didSelectRowSubject
      .map { indexPath in
        let bookmark = reactor.currentState.bookmarks[indexPath.row]
        return Action.didSelect(bookmark)
      }
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

    tableView.rx.didScroll
      .asSignal()
      .throttle(.seconds(1))
      .emit(with: self) { owner, _ in
        owner.triggerPaging()
      }
      .disposed(by: disposeBag)

    navSettingButton.rx.tap
      .withUnretained(reactor)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { reactor, _ in
        reactor.pushSettingScene()
      })
      .disposed(by: disposeBag)

    navCreateBookmarkButton.rx.tap
      .withUnretained(reactor)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { reactor, _ in
        reactor.pushBookmarkCreationScene()
      })
      .disposed(by: disposeBag)
  }

  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.bookmarks }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: [])
      .drive(with: self) { owner, bookmarks in
        owner.applySnapshot(bookmarks: bookmarks)
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

    reactor.state
      .map { $0.deleteBookmark }
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, bookmark in
        owner.deleteBookmark(bookmark)
      })
      .disposed(by: disposeBag)
  }
}

extension HomeViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    for indexPath in indexPaths {
      guard let bookmark = reactor?.currentState.bookmarks[safe: indexPath.row] else {
        return
      }

      let cell = tableView.t_dequeueReusableCell(cellType: BookmarkCell.self, indexPath: indexPath)
      cell.preDownloadImage(url: bookmark.url)
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

  func triggerPaging() {
    let offsetY = tableView.contentOffset.y
    let contentHeight = tableView.contentSize.height
    let height = tableView.frame.height

    if offsetY > (contentHeight - height) && !(reactor?.isPaging ?? true) {
      reactor?.action.onNext(.fetchBookmarks())
    }
  }

  func applySnapshot(bookmarks: [Bookmark]) {
    var snapshot = dataSource.snapshot()
    var newBookmarks: [Bookmark] = []
    let existBookmarks = snapshot.itemIdentifiers

    for bookmark in bookmarks where !existBookmarks.contains(bookmark) {
      if let exist = existBookmarks.first(where: { $0.id == bookmark.id }) {
        snapshot.insertItems([bookmark], afterItem: exist)
        snapshot.deleteItems([exist])
      } else {
        newBookmarks.append(bookmark)
      }
    }

    for existBookmark in existBookmarks where !bookmarks.contains(existBookmark) {
      snapshot.deleteItems([existBookmark])
    }

    if !newBookmarks.isEmpty {
      snapshot.appendItems(newBookmarks)
    }
    dataSource.apply(snapshot)
  }

  func deleteBookmark(_ bookmark: Bookmark?) {
    guard let bookmark else {
      return
    }

    var snapshot = dataSource.snapshot()
    snapshot.deleteItems([bookmark])
    dataSource.apply(snapshot)
  }
}


