//
//  FolderViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import ReactorKit

final class FolderViewController: UIViewController, View {
  private let navigationBar: TidifyNavigationBar
  
  private let containerView: UIView = .init().then {
    $0.cornerRadius([.topLeft, .topRight], radius: 16)
    $0.backgroundColor = .white
  }
  
  private lazy var emptyLabel: UILabel = .init().then {
    $0.textColor = .t_indigo02()
    $0.text = "폴더에 정리하고 싶지 않나요?"
    $0.font = .t_EB(16)
  }
  
  private lazy var folderTableView: TidifyTableView = .init(tabType: .folder)
  
  var disposeBag: DisposeBag = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  init(_ navigationBar: TidifyNavigationBar) {
    self.navigationBar = navigationBar
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: FolderReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

private extension FolderViewController {
  typealias Action = FolderReactor.Action
  
  func setupUI() {
    view.backgroundColor = .t_background()
    
    view.addSubview(navigationBar)
    view.addSubview(containerView)
    containerView.addSubview(emptyLabel)
    containerView.addSubview(folderTableView)
    
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.182)
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.bottom.trailing.equalToSuperview()
    }
    
    folderTableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalToSuperview().inset(Self.viewHeight * 0.142)
    }
    
    emptyLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(32)
      $0.height.equalTo(20)
      $0.centerX.equalToSuperview()
    }
  }
  
  func bindAction(reactor: FolderReactor) {
    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action )
      .disposed(by: disposeBag)

    folderTableView.editAction
      .flatMap { row in
        Observable.just(reactor.currentState.folders[row])
      }
      .map { Action.tryEdit($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
    
    folderTableView.deleteAction
      .flatMap { row in
        Observable.just(reactor.currentState.folders[row])
      }
      .map { Action.tryDelete($0) }
      .bind(to: reactor.action)
      .disposed(by: self.disposeBag)
  }
  
  func bindState(reactor: FolderReactor) {
    reactor.state
      .map { $0.folders }
      .bind(to: folderTableView.rx.items(
        cellIdentifier: "\(FolderTableViewCell.self)",
        cellType: FolderTableViewCell.self)) { _, folder, cell in
          cell.configure(folder: folder)
        }
        .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.folders.isEmpty }
      .bind(to: folderTableView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
