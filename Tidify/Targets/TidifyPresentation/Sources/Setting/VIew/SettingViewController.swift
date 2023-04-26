//
//  SettingViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

import ReactorKit
import Kingfisher

final class SettingViewController: UIViewController, View {

  // MARK: - Properties
  private let tableView: UITableView = .init(frame: .zero, style: .grouped)
  private let headerView: SettingTableHeaderView = .init(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
  private let alertPresenter: AlertPresenter

  private let selectedIndexPathSubject: PublishSubject<IndexPath> = .init()
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
  }

  func bind(reactor: SettingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension SettingViewController {
  typealias Action = SettingReactor.Action

  func bindAction(reactor: SettingReactor) {
    selectedIndexPathSubject
      .map { Action.didTapCell(indexPath: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: SettingReactor) {
    reactor.state
      .map { $0.presentAlert }
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, alertType in
        guard let alertType = alertType else { return }
        owner.presentAlert(type: alertType)
      })
      .disposed(by: disposeBag)
  }

  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(tableView)

    tableView.do {
      $0.delegate = self
      $0.dataSource = self
      $0.separatorColor = .clear
      $0.t_registerCellClass(cellType: SettingCell.self)
      $0.tableHeaderView = headerView
      $0.isScrollEnabled = false
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  func presentAlert(type: AlertPresenter.AlertType) {
    var rightButtonAction: ButtonAction? = nil

    if type == .removeAllCache {
      rightButtonAction = { [weak self] in self?.clearAllCache() }
    } else if type == .removeImageCache {
      rightButtonAction = { KingfisherManager.shared.cache.clearMemoryCache() }
    }

    alertPresenter.present(
      on: self,
      alertType: type,
      leftButtonAction: nil,
      rightButtonAction: rightButtonAction)
  }

  func clearAllCache() {
    let cache = KingfisherManager.shared.cache

    cache.clearCache()
    cache.cleanExpiredCache()
  }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return SettingReactor.Sections.allCases.count
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let section = SettingReactor.Sections.init(rawValue: section) else { return 0 }

    return section.numberOfRows
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let section = SettingReactor.Sections.init(rawValue: indexPath.section) else { return .init() }

    let cell: SettingCell = tableView.t_dequeueReusableCell(
      cellType: SettingCell.self,
      indexPath: indexPath
    )
    
    let isLastIndex = section.numberOfRows - 1 == indexPath.row
    if isLastIndex { cell.cornerRadius([.bottomLeft, .bottomRight], radius: 16) }
    
    cell.configure(title: section.rowTitles[indexPath.row], isLastIndex: isLastIndex)
    
    guard indexPath.row == 1 else { return cell }
    
    let bottomBorder = CALayer()
    bottomBorder.frame = CGRect(x: 16, y: 0, width: Self.viewWidth - 16, height: 1)
    bottomBorder.backgroundColor = UIColor.systemGray6.cgColor
    cell.contentView.layer.addSublayer(bottomBorder)
    return cell
  }

  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let section = SettingReactor.Sections.init(rawValue: section) else { return nil }

    let sectionHeaderView: SettingSectionHeaderView = .init(section: section)
    return sectionHeaderView
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    selectedIndexPathSubject.onNext(indexPath)
  }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return 75
  }
}
