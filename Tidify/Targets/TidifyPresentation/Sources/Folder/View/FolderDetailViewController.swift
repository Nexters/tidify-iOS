//
//  FolderDetailViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/11/17.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

import SnapKit

final class FolderDetailViewController: BaseViewController, Coordinatable, Alertable, LoadingIndicatable {

  // MARK: Properties
  weak var coordinator: DefaultFolderDetailCoordinator?
  private let viewModel: FolderDetailViewModel
  private let folder: Folder

  var indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_blue()
    return indicatorView
  }()

  private let topEffectView: UIVisualEffectView = {
    let blurEffect: UIBlurEffect = .init(style: .regular)
    let view: UIVisualEffectView = .init(effect: blurEffect)
    view.backgroundColor = .t_background().withAlphaComponent(0.01)
    return view
  }()

  private lazy var scrollView: UIScrollView = {
    let scrollView: UIScrollView = .init()
    scrollView.backgroundColor = .clear
    scrollView.contentInsetAdjustmentBehavior = .never
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
    tableView.t_registerCellClass(cellType: BookmarkCell.self)
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .white
    tableView.cornerRadius(radius: 15)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()
  
  // MARK: Initializer
  init(viewModel: FolderDetailViewModel, folder: Folder) {
    self.viewModel = viewModel
    self.folder = folder
    super.init(nibName: nil, bundle: nil)
    title = folder.title
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    viewModel.action(.initialize(folderID: folder.id))
    super.viewDidLoad()
    setupLayoutConstraints()
    bindState()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.didFinish()
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(tableView)
    view.addSubview(topEffectView)
    view.addSubview(indicatorView)
  }
}

// MARK: - Private
private extension FolderDetailViewController {
  func setupLayoutConstraints() {
    guard let navigationBarHeight = navigationController?.navigationBar.frame.height else {
      return
    }

    topEffectView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.topPadding + navigationBarHeight)
    }

    indicatorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview().priority(.low)
    }

    tableView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(Self.topPadding + navigationBarHeight + 15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(0)
      $0.bottom.equalToSuperview().offset(-60)
    }
  }

  func bindState() {
    viewModel.$state
      .map { $0.isLoading }
      .receiveOnMain()
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isLoading in
        self?.setIndicatorView(isLoading: isLoading)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.bookmarks }
      .removeDuplicates()
      .receiveOnMain()
      .sink(receiveValue: { [weak self] bookmarks in
        self?.tableView.reloadData()
        self?.updateConstraints(by: bookmarks)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.errorType }
      .compactMap { $0 }
      .filter { $0 == .failFetchBookmarks }
      .receiveOnMain()
      .sink(receiveValue: { [weak self] _ in
        self?.presentAlert(type: .bookmarkFetchError)
      })
      .store(in: &cancellable)
  }

  func updateConstraints(by bookmarks: [Bookmark]) {
    tableView.snp.updateConstraints {
      $0.height.equalTo(bookmarks.count == 0 ? 0 : 60 * bookmarks.count + 20)
    }

    if bookmarks.count == 0 {
      tableView.contentInset = .zero
    } else {
      tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    }
  }
}

// MARK: - UITableViewDataSource
extension FolderDetailViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.state.bookmarks.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
extension FolderDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let bookmark = viewModel.state.bookmarks[safe: indexPath.row] else {
      return
    }

    coordinator?.startWebView(bookmark: bookmark)
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
}

// MARK: - BookmarkCellDelegate
extension FolderDetailViewController: BookmarkCellDelegate {
  func didTapStarButton(bookmarkID: Int) {
    viewModel.action(.didTapStarButton(bookmarkID))
  }
}
