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
  private var willSearch: Bool = .init()
  private let tapGestureRecognizer: UITapGestureRecognizer = .init()
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
    clearTextField()
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
//      $0.layer.borderWidth = 1
//      $0.layer.borderColor = UIColor.t_borderColor().cgColor
      $0.cornerRadius(radius: 20)
    }
    
    searchImageView.do {
      $0.image = .init(named: "icon_search")
    }

    eraseQueryButton.do {
      guard let eraseQueryimage: UIImage = .init(named: "icon_searchField_erase") else { return }
      $0.setImage(eraseQueryimage, for: .normal)
    }

    tapGestureRecognizer.do {
      $0.cancelsTouchesInView = false
    }

    tableView.do {
      $0.separatorStyle = .none
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: SearchHistoryCell.self)
      $0.t_registerCellClass(cellType: BookmarkCell.self)
      $0.delegate = self
      $0.dataSource = self
      $0.bounces = false
      $0.showsVerticalScrollIndicator = false
      $0.addGestureRecognizer(tapGestureRecognizer)
      if #available(iOS 15, *) {
        $0.sectionHeaderTopPadding = .zero
      }
    }

    searchTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(38)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(Self.viewWidth * 0.149)
    }
    
    searchImageView.snp.makeConstraints {
      $0.top.leading.bottom.equalTo(searchTextField).inset(16)
      $0.height.equalTo(searchImageView.snp.width)
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

    searchTextField.rx.controlEvent(.editingChanged)
      .map { Action.inputKeyword }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    searchTextField.rx.controlEvent(.editingDidEnd)
      .withUnretained(self)
      .filter { owner, _ in owner.willSearch }
      .map { owner, _ -> String in
        owner.willSearch = false
        return owner.searchTextField.text ?? ""
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
    
    reactor.state
      .map { $0.viewMode }
      .distinctUntilChanged()
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, viewMode in
        guard owner.tableView.superview != nil else { return }
        let isHistoryMode = viewMode == .history
        
        owner.tableView.snp.updateConstraints {
          $0.top.equalTo(owner.searchTextField.snp.bottom).offset(isHistoryMode ? 24 : 56)
          $0.leading.trailing.equalToSuperview().inset(isHistoryMode ? 0 : 20)
        }
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

    searchTextField.rx.controlEvent(.editingDidEndOnExit)
      .bind(with: self, onNext: { owner, _ in
        owner.willSearch = true
      })
      .disposed(by: disposeBag)

    searchTextField.rx.text.orEmpty
      .filter { $0.count == 1 && $0 == " " }
      .map { _ in "" }
      .bind(to: searchTextField.rx.text)
      .disposed(by: disposeBag)

    Driver.merge(
      view.addTap().rx.event.asDriver(),
      tapGestureRecognizer.rx.event.asDriver()
    )
    .drive(with: self, onNext: { owner, _ in
      owner.view.endEditing(true)
    })
    .disposed(by: disposeBag)
  }
  
  func clearTextField() {
    searchTextField.text = nil
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
    guard reactor?.currentState.viewMode == .history else { return nil }
    return headerView
  }

  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath
  ) -> CGFloat {
    let rowHeight = Self.viewWidth * 0.149
    return reactor?.currentState.viewMode == .history ? rowHeight : rowHeight + 20
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let currentState = reactor?.currentState else { return }
    let row = indexPath.row
    
    switch currentState.viewMode {
    case .history:
      willSearch = true
      searchTextField.becomeFirstResponder()
      searchTextField.text = currentState.searchHistory[row]
      searchTextField.endEditing(true)
    case .search:
      let action = SearchReactor.Action.didSelectBookmark(currentState.searchResult[row])
      reactor?.action.onNext(action)
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }

  func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    guard reactor?.currentState.viewMode == .search,
          let bookmarksCount = reactor?.currentState.searchResult.count,
          let searchText = searchTextField.text else {
      return
    }

    if indexPath.row >= bookmarksCount - 5 {
      reactor?.action.onNext(.searchQuery(searchText))
    }
  }
}
