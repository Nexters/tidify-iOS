//
//  FolderDetailViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/11/17.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import ReactorKit

final class FolderDetailViewController: UIViewController, View, Alertable {
  private let navigationBar: TidifyNavigationBar
  private let folder: Folder
  private let containerView: UIView = .init()
  private lazy var emptyLabel: UILabel = .init()
  private lazy var bookmarkTableView: TidifyTableView = .init(tabType: .bookmark)
  var disposeBag: DisposeBag = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    bindTableViewAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }

  init(folder: Folder, navigationBar: TidifyNavigationBar) {
    self.navigationBar = navigationBar
    self.folder = folder
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: FolderDetailReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

private extension FolderDetailViewController {
  typealias Action = FolderDetailReactor.Action
  
  func setupUI() {
    view.backgroundColor = .t_background()
    
    view.addSubview(navigationBar)
    view.addSubview(containerView)
    containerView.addSubview(emptyLabel)
    containerView.addSubview(bookmarkTableView)
    
    containerView.do {
      $0.cornerRadius([.topLeft, .topRight], radius: 16)
      $0.backgroundColor = .white
    }
    
    emptyLabel.do {
      $0.textColor = .t_indigo()
      $0.text = "폴더가 비어있어요!"
      $0.font = .t_EB(16)
    }

    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.182)
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.bottom.trailing.equalToSuperview()
    }
    
    bookmarkTableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(Self.viewHeight * 0.142)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.height.equalTo(20)
      $0.centerX.equalToSuperview()
    }
  }
  
  func bindAction(reactor: FolderDetailReactor) {
    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action )
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: FolderDetailReactor) {
    reactor.state
      .map { $0.bookmarks }
      .bind(to: bookmarkTableView.rx.items(
        cellIdentifier: "\(BookmarkCell.self)",
        cellType: BookmarkCell.self)) { _, folder, cell in
          cell.configure(bookmark: folder)
        }
        .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.bookmarks.isEmpty }
      .bind(to: bookmarkTableView.rx.isHidden)
      .disposed(by: disposeBag)
  }

  func bindTableViewAction() {
    guard let reactor = reactor else {
      return
    }

    bookmarkTableView.rx.modelSelected(Bookmark.self)
      .map { Action.didSelect($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    bookmarkTableView.editAction
      .flatMap { row in
        Observable.just(reactor.currentState.bookmarks[row])
      }
      .map { Action.tryEdit($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)

    bookmarkTableView.deleteAction
      .withUnretained(self)
      .flatMap { owner, row -> PublishSubject<Int> in owner.presentDeletionAlert(row) }
      .map { Action.tryDelete(reactor.currentState.bookmarks[$0]) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }

  func presentDeletionAlert(_ row: Int) -> PublishSubject<Int> {
    let deletedFolderRow: PublishSubject<Int> = .init()
    presentAlert(
      type: .deleteBookmark,
      rightButtonTapHandler: { deletedFolderRow.onNext(row) }
    )

    return deletedFolderRow
  }
}
