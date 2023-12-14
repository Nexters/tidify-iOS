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
import Combine

final class HomeViewController: BaseViewController, Alertable, Coordinatable, LoadingIndicatable {

  // MARK: - Properties
  private let navigationBar: TidifyNavigationBar
  private let viewModel: HomeViewModel
  weak var coordinator: DefaultHomeCoordinator?
  private var scrollWorkItem: DispatchWorkItem?
  private var scrollOffset: CGFloat = 0

  var indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_blue()
    indicatorView.hidesWhenStopped = true
    return indicatorView
  }()

  private lazy var searchButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(named: "home_search_bookmark"), for: .normal)
    button.setTitle("  북마크 찾기", for: .normal)
    button.setTitleColor(.t_gray(weight: 600), for: .normal)
    button.titleLabel?.font = .t_SB(14)
    button.cornerRadius(radius: 10)
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
    button.backgroundColor = .t_gray(weight: 100)
    button.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    return button
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
    let tableView: UITableView = .init(frame: .zero)
    tableView.t_registerCellClasses([EmptyGuideCell.self, BookmarkCell.self])
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .white
    tableView.cornerRadius(radius: 15)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()

  // MARK: - Initializer
  init(navigationBar: TidifyNavigationBar, viewModel: HomeViewModel) {
    self.navigationBar = navigationBar
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayoutConstraints()
    bindState()
    coordinator?.navigationBarDelegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.action(.initialize)
    navigationController?.navigationBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(indicatorView)
    view.addSubview(navigationBar)
    view.addSubview(searchButton)
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(tableView)
  }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let bookmarkCount: Int = viewModel.state.bookmarks.count
    return bookmarkCount == 0 ? 1 : bookmarkCount
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.state.bookmarks.isEmpty {
      let cell: EmptyGuideCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      cell.setupBookmarkGuideLabel()
      cell.delegate = self
      return cell
    }

    guard let bookmark = viewModel.state.bookmarks[safe: indexPath.row] else {
      return .init()
    }

    let cell: BookmarkCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
    cell.configure(bookmark: bookmark)
    cell.delegate = self

    return cell
  }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.state.bookmarks.isEmpty ? 254 : 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let bookmark = viewModel.state.bookmarks[safe: indexPath.row] else {
      return
    }

    coordinator?.pushWebView(bookmark: bookmark)
  }

  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    guard let bookmark = viewModel.state.bookmarks[safe: indexPath.row] else {
      return .none
    }

    let editAction: UIContextualAction = {
      let action: UIContextualAction = .init(
        style: .normal,
        title: "편집",
        handler: { [weak coordinator] _, _, completion in
          coordinator?.pushEditBookmarkScene(bookmark: bookmark)
          completion(true)
        })
      action.backgroundColor = .t_blue()
      return action
    }()

    let deleteAction: UIContextualAction = {
      let action: UIContextualAction = .init(
        style: .destructive,
        title: "삭제",
        handler: { [weak self] _, _, completion in
          self?.presentAlert(type: .deleteBookmark, rightButtonTapHandler: {
            self?.viewModel.action(.didTapDelete(bookmark.id))
          })
          completion(true)
        })
      action.backgroundColor = .t_red()
      return action
    }()

    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentSizeHeight = scrollView.contentSize.height
    let paginationY = scrollView.contentOffset.y + scrollView.frame.height
    scrollOffset = scrollView.contentOffset.y

    guard paginationY + 100 > contentSizeHeight,
          scrollWorkItem == nil else {
      return
    }

    viewModel.action(.didScroll)
    let workItem = DispatchWorkItem { [weak self] in
      self?.scrollWorkItem?.cancel()
      self?.scrollWorkItem = nil
      if self?.scrollOffset != scrollView.contentOffset.y {
        self?.viewModel.action(.didScroll)
      }
    }

    scrollWorkItem = workItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
  }
}

// MARK: - EmptyBookmarkGuideCellDelegate
extension HomeViewController: EmptyGuideCellDelegate {
  func didTapShowGuideButton() {
    // TODO: 디자인 작업 이후 온보딩으로 이동
  }
}
// MARK: - BookmarkCellDelegate
extension HomeViewController: BookmarkCellDelegate {
  func didTapStarButton(bookmarkID: Int) {
    viewModel.action(.didTapStarButton(bookmarkID))
  }
}

// MARK: - Private
private extension HomeViewController {
  func setupLayoutConstraints() {
    indicatorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.05)
    }

    searchButton.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(40)
    }

    scrollView.snp.makeConstraints {
      $0.top.equalTo(searchButton.snp.bottom).offset(15)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }

    tableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(0)
      $0.bottom.equalToSuperview().offset(-120)
    }
  }

  func bindState() {
    viewModel.$state
      .map { $0.isLoading }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isLoading in
        self?.setIndicatorView(isLoading: isLoading)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.bookmarks }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] bookmarks in
        self?.tableView.reloadData()
        self?.updateConstraints(by: bookmarks)
      })
      .store(in: &cancellable)
  }

  func updateConstraints(by bookmarks: [Bookmark]) {
    tableView.snp.updateConstraints {
      $0.height.equalTo(bookmarks.count == 0 ? 254 : 60 * bookmarks.count + 20)
    }

    if bookmarks.count == 0 {
      tableView.contentInset = .init()
    } else {
      tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    }
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

  @objc func didTapSearchButton() {
    coordinator?.pushSearchScene()
  }
}

extension HomeViewController: HomeNavigationBarDelegate {
  func didTapBookmarkButton() {
    viewModel.action(.didTapCategory(.normal))
  }

  func didTapFavoriteButton() {
    viewModel.action(.didTapCategory(.favorite))
  }
}
