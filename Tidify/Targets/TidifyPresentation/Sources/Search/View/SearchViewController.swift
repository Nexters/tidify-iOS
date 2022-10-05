//
//  SearchViewController.swift
//  TidifyPresentation
//
//  Created by ian on 2022/10/05.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxCocoa
import ReactorKit
import SnapKit
import Then

final class SearchViewController: UIViewController, View {

  // MARK: - Properties
  private let searchTextField: UITextField = .init()
  private let headerView: SearchHeaderView = .init()
  private lazy var tableView: UITableView = .init(frame: .zero, style: .grouped)

  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: SearchReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension SearchViewController {
  func setupUI() {
    view.addSubview(searchTextField)
    view.addSubview(tableView)

    view.backgroundColor = .white

    let searchImageView: UIImageView = .init().then {
      $0.image = .init(named: "icon_search")
      $0.frame = .init(
        x: 15,
        y: 0,
        width: $0.image?.size.width ?? 0,
        height: $0.image?.size.height ?? 0
      )
    }

    let textFieldLeftView: UIView = .init().then {
      $0.frame = .init(
        x: 0,
        y: 0,
        width: searchImageView.frame.width + 30,
        height: searchImageView.frame.height
      )
      $0.addSubview(searchImageView)
    }

    searchTextField.do {
      $0.placeholder = "어떤 것을 찾으시나요?"
      $0.leftView = textFieldLeftView
      $0.leftViewMode = .always
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.cornerRadius(radius: 20)
    }

    tableView.do {
      $0.separatorStyle = .none
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: SearchHistoryCell.self)
      $0.t_registerCellClass(cellType: BookmarkCell.self)
      $0.delegate = self
      $0.dataSource = self
      if #available(iOS 15, *) {
        $0.sectionHeaderTopPadding = .zero
      }
    }

    searchTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(38)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.07)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }

  func bindAction(reactor: SearchReactor) {
    typealias Action = SearchReactor.Action

    headerView.eraseAllButtonTapObservable
      .map { Action.requestEraseAllHistory }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    searchTextField.rx.text
      .orEmpty
      .map { Action.typingQuery($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: SearchReactor) {
    reactor.state
      .map { $0.viewMode }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, _ in
        owner.tableView.reloadData()
      })
      .disposed(by: disposeBag)
  }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let currentState = reactor?.currentState else { return 0 }

    switch currentState.viewMode {
    case .history:
      return currentState.searchHistory.count

    case .search:
      return currentState.searchResult.count
    }
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let currentState = reactor?.currentState else { return .init() }

    let cell: UITableViewCell
    switch currentState.viewMode {
    case .history:
      let searchHistoryCell: SearchHistoryCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      searchHistoryCell.configure(title: currentState.searchHistory[indexPath.row])

      cell = searchHistoryCell

    case .search:
      let bookmarkCell: BookmarkCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      bookmarkCell.configure(bookmark: currentState.searchResult[indexPath.row])

      cell = bookmarkCell
    }

    return cell
  }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    let viewMode = reactor?.currentState.viewMode ?? .search

    switch viewMode {
    case .history:
      return headerView
    case .search:
      return nil
    }
  }

  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    let viewMode = reactor?.currentState.viewMode ?? .search

    switch viewMode {
    case .history:
      return view.frame.height * 0.02
    case .search:
      return .zero
    }
  }
}
