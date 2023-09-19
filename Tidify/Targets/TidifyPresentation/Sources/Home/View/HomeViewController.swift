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

final class HomeViewController: UIViewController, UIScrollViewDelegate, Alertable {

  // MARK: - Properties
  private var navigationBar: TidifyNavigationBar!
  private let navSettingButton: UIButton = .init()
  private let navCreateBookmarkButton: UIButton = .init()

  private lazy var searchTextField: UITextField = {
    let textField: UITextField = .init()
    textField.attributedPlaceholder = .init(string: "북마크 찾기", attributes: [
      .font: UIFont.t_SB(14),
      .foregroundColor: UIColor.init(110, 121, 135)
    ])
    textField.backgroundColor = .init(224, 227, 230)
    textField.cornerRadius(radius: 10)
    let leftView = UIImageView(frame: .init(x: 0, y: 0, width: 16, height: 16))
    leftView.image = .init(named: "home_search_bookmark")
    textField.leftView = leftView
    textField.leftViewMode = .unlessEditing
    textField.delegate = self
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()

  private lazy var tableView: UITableView = {
    let tableView: UITableView = .init(frame: .zero)
    tableView.keyboardDismissMode = .onDrag
    tableView.delegate = self
    tableView.dataSource = self
    tableView.t_registerCellClasses([EmptyBookmarkGuideCell.self, BookmarkCell.self, EmptyBookmarkSearchResultCell.self])
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 250
    tableView.cornerRadius([.topLeft, .topRight], radius: 15)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  private let viewModel: HomeViewModel
  private var cancellable: Set<AnyCancellable> = []

  // MARK: - Initializer
  init(viewModel: HomeViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()

    viewModel.action(.viewDidLoad)

    viewModel.$state
      .map(\.bookmarks)
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak tableView] _ in
        tableView?.reloadData()
      })
      .store(in: &cancellable)
  }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    if viewModel.state.bookmarks.isEmpty {
      return 1
    }

    return viewModel.state.bookmarks.count
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    if viewModel.state.bookmarks.isEmpty {
      switch viewModel.state.viewMode {
      case .bookmarkList:
        let cell: EmptyBookmarkGuideCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
        cell.delegate = self
        return cell
      case .search:
        let cell: EmptyBookmarkSearchResultCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
        return cell
      }
    } else {
      guard let bookmark = viewModel.state.bookmarks[safe: indexPath.row] else {
        assertionFailure("Bookmarks Index Out of bound")
        return .init()
      }
      let cell: BookmarkCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
      cell.configure(bookmark: bookmark)
      return cell
    }
  }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if viewModel.state.bookmarks.isEmpty {
      return viewModel.state.viewMode == .bookmarkList ? 250 : 140
    } else {
      return 80
    }
  }
}

// MARK: - EmptyBookmarkGuideCellDelegate
extension HomeViewController: EmptyBookmarkGuideCellDelegate {
  func didTapShowGuideButton() {
    // TODO: 디자인 작업 이후 온보딩으로 이동
  }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    guard let text = textField.text else {
      return false
    }

    viewModel.action(.search(keyword: text))
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    guard !(textField.text?.isEmpty ?? true) else {
      return
    }
  }
}

// MARK: - Private
private extension HomeViewController {
  func setupUI() {
    [searchTextField, tableView].forEach { view.addSubview($0) }
    view.backgroundColor = .t_background()

    navSettingButton.do {
      $0.setImage(.init(named: "profileIcon"), for: .normal)
      $0.frame = .init(
        x: 0,
        y: 0,
        width: UIViewController.viewHeight * 0.043, height: UIViewController.viewHeight * 0.049
      )
    }

    navCreateBookmarkButton.do {
      $0.setImage(.init(named: "createBookMarkIcon"), for: .normal)
      $0.frame = .init(
        x: 0,
        y: 0,
        width: UIViewController.viewWidth * 0.506,
        height: UIViewController.viewHeight * 0.049
      )
    }

    navigationBar = .init(.home, leftButton: navSettingButton, rightButton: navCreateBookmarkButton)
    navigationBar.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(navigationBar)

    NSLayoutConstraint.activate([
      navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
      navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      navigationBar.heightAnchor.constraint(equalToConstant: Self.viewHeight * 0.182),

      searchTextField.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 10),
      searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
      searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
      searchTextField.heightAnchor.constraint(equalToConstant: 40),

      tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 15),
      tableView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Private Extension
private extension HomeViewController {
  func presentDeleteBookmarkAlert(deleteTargetRow: Int) {
//    presentAlert(
//      type: .deleteBookmark,
//      rightButtonTapHandler: { [weak self] in self?.deleteBookmarkSubject.onNext(deleteTargetRow) }
//    )
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

//  @objc
//  func didChangeTextField(_ textfield: UITextField) {
//    guard let text = textfield.text else {
//      return
//    }
//
//    viewModel.action(.search(keyword: text))
//  }
}
