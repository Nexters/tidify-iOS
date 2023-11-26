//
//  FolderViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import SnapKit

final class FolderViewController: BaseViewController, Alertable, Coordinatable {

  // MARK: Properties
  private let navigationBar: TidifyNavigationBar
  private let viewModel: FolderViewModel
  weak var coordinator: DefaultFolderCoordinator?
  private var scrollWorkItem: DispatchWorkItem?
  private var scrollOffset: CGFloat = 0

  private let indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_blue()
    return indicatorView
  }()

  private let searchButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(named: "home_search_bookmark"), for: .normal)
    button.setTitle("  북마크 찾기", for: .normal)
    button.setTitleColor(.t_gray(weight: 600), for: .normal)
    button.titleLabel?.font = .t_SB(14)
    button.cornerRadius(radius: 10)
    button.contentHorizontalAlignment = .left
    button.contentEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
    button.backgroundColor = .t_gray(weight: 100)
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
    let tableView: UITableView = .init()
    tableView.t_registerCellClasses([EmptyGuideCell.self, FolderTableViewCell.self])
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .white
    tableView.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    tableView.cornerRadius(radius: 15)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()

  // MARK: Initializer
  init(navigationBar: TidifyNavigationBar, viewModel: FolderViewModel) {
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
    viewModel.action(.viewDidLoad)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  override func setupViews() {
    super.setupViews()
    
    view.addSubview(navigationBar)
    view.addSubview(searchButton)
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(tableView)
  }
}

// MARK: - Private
private extension FolderViewController {
  func setupLayoutConstraints() {
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
      $0.height.equalTo(Self.viewHeight - 40 - Self.viewHeight * 0.05)
    }

    tableView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(0)
    }
  }

  func bindState() {
    viewModel.$state
      .map { $0.isLoading }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isLoading in
        if isLoading {
          self?.indicatorView.startAnimating()
        } else {
          self?.indicatorView.isHidden = true
        }
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.folders }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] folders in
        self?.tableView.reloadData()
        self?.updateConstraints(by: folders)
      })
      .store(in: &cancellable)
  }

  func updateConstraints(by folders: [Folder]) {
    if folders.count == 0 {
      tableView.snp.updateConstraints {
        $0.height.equalTo(254)
      }
    } else {
      let updatedHeight = Int((Self.viewHeight * 0.07)) * folders.count + 20

      tableView.snp.updateConstraints {
        $0.height.equalTo(updatedHeight)
      }
      contentView.snp.updateConstraints {
        $0.height.equalTo(updatedHeight + 120)
      }
    }
  }
}

// MARK: - Extension
extension FolderViewController: FolderNavigationBarDelegate {
  func didTapFolderButton() {
    viewModel.action(.didTapCategory(.normal))
  }

  func didTapSubscribeButton() {
    viewModel.action(.didTapCategory(.subscribe))
  }

  func didTapShareButton() {
    viewModel.action(.didTapCategory(.share))
  }
}

extension FolderViewController: EmptyGuideCellDelegate {
  func didTapShowGuideButton() {
    // TODO: 디자인 작업 이후 온보딩으로 이동
  }
}

extension FolderViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let folderCount: Int = viewModel.state.folders.count

    if folderCount == 0 {
      tableView.contentInset = .zero
      return 1
    } else {
      return folderCount
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if viewModel.state.folders.isEmpty {
      let cell: EmptyGuideCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      cell.setupFolderGuideLabel(category: viewModel.state.category)
      cell.delegate = self
      return cell
    }

    guard let folder = viewModel.state.folders[safe: indexPath.row] else {
      return .init()
    }

    let cell: FolderTableViewCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
    cell.configure(folder: folder)

    return cell
  }
}

extension FolderViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return viewModel.state.folders.isEmpty ? 254 : Self.viewHeight * 0.07
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let folder = viewModel.state.folders[safe: indexPath.row] else {
      return
    }

    viewModel.action(.didSelectFolder(folder))
  }

  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    guard let folder = viewModel.state.folders[safe: indexPath.row] else {
      return .none
    }

    let editAction: UIContextualAction = {
      let action: UIContextualAction = .init(
        style: .normal,
        title: "편집",
        handler: { [weak viewModel] _, _, completion in
          viewModel?.action(.didTapEdit(folder))
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
          self?.presentAlert(type: .deleteFolder, rightButtonTapHandler: {
            self?.viewModel.action(.didTapDelete(folder))
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
