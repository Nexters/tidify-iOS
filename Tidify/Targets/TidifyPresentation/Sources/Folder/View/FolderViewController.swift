//
//  FolderViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

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
  
  private lazy var folderTableView: UITableView = .init().then {
    $0.t_registerCellClass(cellType: FolderTableViewCell.self)
    $0.separatorStyle = .none
    $0.rowHeight = (Self.viewHeight * 0.0689) + 24
    $0.showsVerticalScrollIndicator = false
  }
  
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
    view.backgroundColor = .init(235, 235, 240)
    
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
    self.rx.viewDidLoad
      .map { Action.fetchFolders }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: FolderReactor) {
    reactor.state
      .map { $0.folders }
      .bind(to: folderTableView.rx.items) { tableView, row, item in
        guard let cell = tableView.dequeueReusableCell(
          withIdentifier: "FolderTableViewCell",
          for: IndexPath(row: row, section: 0)
        ) as? FolderTableViewCell
        else { return UITableViewCell() }

        cell.setupUI(folderName: item.name, folderColor: item.color)
        return cell
      }
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.folders.isEmpty }
      .bind(to: folderTableView.rx.isHidden)
      .disposed(by: disposeBag)
  }
}
