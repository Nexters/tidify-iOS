//
//  SearchViewController.swift
//  TidifyPresentation
//
//  Created by ian on 2022/10/05.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyCore
import TidifyDomain
import UIKit

import SnapKit

final class SearchViewController: BaseViewController, Coordinatable {

  // MARK: Properties
  weak var coordinator: DefaultSearchCoordinator?
  private let viewModel: SearchViewModel
  private var scrollWorkItem: DispatchWorkItem?
  private var scrollOffset: CGFloat = 0

  private let searchTextField: UITextField = {
    let textField: UITextField = .init()
    textField.attributedPlaceholder = .init(string: "북마크 찾기", attributes: [
      .font: UIFont.t_SB(14),
      .foregroundColor: UIColor.t_gray(weight: 600)
    ])
    textField.backgroundColor = .t_gray(weight: 100)
    textField.cornerRadius(radius: 10)
    let leftView: UIView = .init(frame: .init(x: 0, y: 0, width: 40, height: 16))
    let leftImageView: UIImageView = .init(frame: .init(x: 15, y: 0, width: 16, height: 16))
    leftImageView.image = .init(named: "home_search_bookmark")
    leftView.addSubview(leftImageView)
    textField.leftView = leftView
    textField.leftViewMode = .always
    textField.clearButtonMode = .whileEditing
    return textField
  }()

  private lazy var scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.backgroundColor = .clear
    scrollView.delegate = self
    return scrollView
  }()

  private lazy var contentView: UIView = {
    let contentView: UIView = .init()
    contentView.backgroundColor = .clear
    return contentView
  }()

  private lazy var tableView: UITableView = {
    let tableView: UITableView = .init()
    tableView.t_registerCellClasses([BookmarkCell.self, SearchTableViewCell.self])
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .white
    tableView.cornerRadius(radius: 15)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self

    if #available(iOS 15, *) {
      tableView.sectionHeaderTopPadding = 0
    }
    return tableView
  }()

  private var searchHistoryTableViewHeight: Int {
    let searchHistoryCount = UserProperties.searchHistory.count
    return searchHistoryCount == 0 ? 0 : 70 + 50 * searchHistoryCount
  }

  private var searchResultTableViewHeight: Int {
    let searchResultCount = viewModel.state.searchResult.count
    return searchResultCount == 0 ? 0 : 60 * searchResultCount + 20
  }

  private var isHistoryMode: Bool {
    searchTextField.text == ""
  }

  // MARK: Initializer
  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "검색"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayoutConstraints()
    bindSearchTextField()
    bindState()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    searchTextField.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.didFinish()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(searchTextField)
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(tableView)
  }
}

// MARK: - Private
private extension SearchViewController {
  func setupLayoutConstraints() {
    searchTextField.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(40)
    }

    scrollView.snp.makeConstraints {
      $0.top.equalTo(searchTextField.snp.bottom).offset(15)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }

    tableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(searchHistoryTableViewHeight)
      $0.bottom.equalToSuperview().offset(-60)
    }
  }

  func bindSearchTextField() {
    searchTextField.publisher
      .debounce(for: 0.3, scheduler: DispatchQueue.global())
      .sink(receiveValue: { [weak self] text in
        self?.viewModel.action(.searchQuery(text))
      })
      .store(in: &cancellable)
  }

  func bindState() {
    viewModel.$state
      .map { $0.searchResult }
      .receiveOnMain()
      .sink(receiveValue: { [weak self] _ in
        self?.updateConstraints()
      })
      .store(in: &cancellable)
  }

  func updateConstraints() {
    tableView.snp.updateConstraints {
      $0.height.equalTo(isHistoryMode ? searchHistoryTableViewHeight : searchResultTableViewHeight)
    }
    tableView.contentInset = .init(top: isHistoryMode ? 0 : 10, left: 0, bottom: 10, right: 0)
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return isHistoryMode ? UserProperties.searchHistory.count : viewModel.state.searchResult.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if searchTextField.text == "" {
      guard let history = UserProperties.searchHistory[safe: indexPath.row] else {
        return .init()
      }
      let cell: SearchTableViewCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      cell.configure(title: history)
      return cell
    } else {
      guard let result = viewModel.state.searchResult[safe: indexPath.row] else {
        return .init()
      }

      let cell: BookmarkCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      cell.configure(bookmark: result)
      cell.delegate = self

      return cell
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard isHistoryMode else {
      return nil
    }

    let headerView: SearchTableViewHeaderView = .init()
    headerView.delegate = self
    return headerView
  }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return isHistoryMode ? 50 : 60
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if searchTextField.text != "" {
      return 0
    }

    return UserProperties.searchHistory.isEmpty ? 0 : 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if isHistoryMode {
      guard let history = UserProperties.searchHistory[safe: indexPath.row] else {
        return
      }

      searchTextField.text = history
      viewModel.action(.searchQuery(history))
    } else {
      guard let bookmark = viewModel.state.searchResult[safe: indexPath.row] else {
        return
      }

      viewModel.action(.saveHistory(bookmark.name))
      coordinator?.startWebView(bookmark: bookmark)
    }
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    view.endEditing(true)
    let contentSizeHeight = scrollView.contentSize.height
    let paginationY = scrollView.contentOffset.y + scrollView.frame.height
    scrollOffset = scrollView.contentOffset.y

    guard paginationY + 100 > contentSizeHeight,
          scrollWorkItem == nil else {
      return
    }

    viewModel.action(.didScroll(searchTextField.text ?? ""))
    let workItem = DispatchWorkItem { [weak self] in
      self?.scrollWorkItem?.cancel()
      self?.scrollWorkItem = nil
      if self?.scrollOffset != scrollView.contentOffset.y {
        self?.viewModel.action(.didScroll(self?.searchTextField.text ?? ""))
      }
    }

    scrollWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
  }
}

// MARK: - BookmarkCellDelegate
extension SearchViewController: BookmarkCellDelegate {
  func didTapStarButton(bookmarkID: Int) {
    guard let bookmark = viewModel.state.searchResult.first(where: { $0.id == bookmarkID }) else {
      return
    }

    viewModel.action(.saveHistory(bookmark.name))
    viewModel.action(.didTapStarButton(bookmarkID))
  }
}

// MARK: - EraseHistoryButtonDelegate
extension SearchViewController: EraseHistoryButtonDelegate {
  func didTapEraseButton() {
    UserProperties.searchHistory = []
    updateConstraints()
  }
}
