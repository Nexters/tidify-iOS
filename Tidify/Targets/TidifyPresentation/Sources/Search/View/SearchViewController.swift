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
  private let searchImageView: UIImageView = .init()
  private let eraseQueryButton: UIButton = .init()
  private let headerView: SearchHeaderView = .init()
  private lazy var tableView: UITableView = .init(frame: .zero, style: .grouped)
  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBarHidden(true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    setupNavigationBarHidden(false)
  }

  func bind(reactor: SearchReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra()
  }
}

// MARK: - Private
private extension SearchViewController {
  func setupNavigationBarHidden(_ status: Bool) {
    navigationController?.navigationBar.isHidden = status
  }
  
  func setupUI() {
    view.backgroundColor = .white
    
    view.addSubview(searchTextField)
    view.addSubview(searchImageView)
    view.addSubview(eraseQueryButton)
    view.addSubview(tableView)
    
    searchTextField.do {
      $0.placeholder = "어떤 것을 찾으시나요?"
      $0.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 56, height: 1))
      $0.leftViewMode = .always
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.cornerRadius(radius: 20)
    }
    
    searchImageView.do {
      $0.image = .init(named: "icon_search")
    }

    eraseQueryButton.do {
      guard let eraseQueryimage: UIImage = .init(named: "icon_searchField_erase") else { return }
      $0.setImage(eraseQueryimage, for: .normal)
    }

    tableView.do {
      $0.separatorStyle = .none
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: SearchHistoryCell.self)
      $0.t_registerCellClass(cellType: BookmarkCell.self)
      $0.delegate = self
      $0.dataSource = self
      $0.bounces = false
      if #available(iOS 15, *) {
        $0.sectionHeaderTopPadding = .zero
      }
    }

    searchTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(38)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalToSuperview().multipliedBy(0.068)
    }
    
    searchImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalTo(searchTextField).inset(16)
    }
    
    eraseQueryButton.snp.makeConstraints {
      $0.top.bottom.equalTo(searchTextField).inset(16)
      $0.trailing.equalTo(searchTextField).inset(24)
    }

    tableView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().inset(Self.viewHeight * 0.142)
    }
  }

  func bindAction(reactor: SearchReactor) {
    typealias Action = SearchReactor.Action

    Observable.merge(rx.viewWillAppear, eraseQueryButton.rx.tap.asObservable())
      .map { _ in Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    headerView.eraseAllButtonTapObservable
      .map { Action.requestEraseAllHistory }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    searchTextField.rx.controlEvent(.editingDidEndOnExit)
      .withUnretained(self)
      .map { owner, _ -> String in
        owner.searchTextField.text ?? ""
      }
      .map { Action.searchQuery($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: SearchReactor) {
    let changedViewModeDriver = reactor.state
      .map { $0.viewMode }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .empty())
      .map { _ in }

    let changedSearchHistoryDriver = reactor.state
      .map { $0.searchHistory }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .empty())
      .map { _ in }

    let changedSearchResultDriver = reactor.state
      .map { $0.searchResult }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .empty())
      .map { _ in }

    Driver.merge(
      changedViewModeDriver,
      changedSearchHistoryDriver,
      changedSearchResultDriver
    )
    .drive(with: self, onNext: { owner, _ in
      owner.tableView.reloadData()
    })
    .disposed(by: disposeBag)
  }

  func bindExtra() {
    searchTextField.rx.text
      .orEmpty
      .map { $0.isEmpty }
      .bind(to: eraseQueryButton.rx.isHidden)
      .disposed(by: disposeBag)

    eraseQueryButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { owner, _ in
        owner.searchTextField.text = nil
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
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    return 56
  }
}
