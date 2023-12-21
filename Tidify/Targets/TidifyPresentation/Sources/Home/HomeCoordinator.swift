//
//  HomeCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol HomeNavigationBarDelegate: AnyObject {
  func didTapBookmarkButton()
  func didTapFavoriteButton()
}

protocol HomeCoordinator: Coordinator {

  // MARK: Methods
  func pushSettingScene()
  func pushEditBookmarkScene(bookmark: Bookmark)
  func pushSearchScene()
  func startWebView(bookmark: Bookmark)

  // MARK: Properties
  var navigationBarDelegate: HomeNavigationBarDelegate? { get set }
}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  weak var navigationBarDelegate: HomeNavigationBarDelegate?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  private lazy var bookmarkButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("북마크", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
    button.titleLabel?.font = .t_EB(22)
    button.addTarget(self, action: #selector(didTapBookmarkButton), for: .touchUpInside)
    return button
  }()

  private lazy var favoriteButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("즐겨찾기", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_EB(22)
    button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
    return button
  }()

  private let leftButtonStackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.distribution = .equalSpacing
    stackView.spacing = 15
    return stackView
  }()

  private lazy var settingButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(named: "settingButtonIcon"), for: .normal)
    button.addTarget(self, action: #selector(pushSettingScene), for: .touchUpInside)
    return button
  }()

  // MARK: - Initializer
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {}
  
  func startPush() -> UIViewController {
    guard let useCase: BookmarkListUseCase = DIContainer.shared.resolve(type: BookmarkListUseCase.self) else {
      fatalError()
    }

    [bookmarkButton, favoriteButton].forEach {
      leftButtonStackView.addArrangedSubview($0)
    }

    let navigationBar: TidifyNavigationBar = .init(
      leftButtonStackView: leftButtonStackView,
      settingButton: settingButton
    )

    let viewModel: HomeViewModel = .init(useCase: useCase)

    let viewController: HomeViewController = .init(
      navigationBar: navigationBar,
      viewModel: viewModel
    )
    viewController.coordinator = self

    return viewController
  }

  @objc func pushSettingScene() {
    guard let settingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self)
            as? DefaultSettingCoordinator else { return }
    let settingViewController = settingCoordinator.startPush()
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    navigationController.pushViewController(settingViewController, animated: true)
  }

  func pushEditBookmarkScene(bookmark: Bookmark) {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    let bookmarkEditViewController = bookmarkCreationCoordinator.startPush(type: .edit, originBookmark: bookmark)
    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    navigationController.pushViewController(bookmarkEditViewController, animated: true)
  }

  func pushSearchScene() {
    guard let searchCoordinator = DIContainer.shared.resolve(type: SearchCoordinator.self)
            as? DefaultSearchCoordinator else {
      return
    }

    let searchViewController = searchCoordinator.startPush()
    navigationController.pushViewController(searchViewController, animated: false)
  }

  func startWebView(bookmark: Bookmark) {
    let webViewController: WebViewController = .init(bookmark: bookmark)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}

private extension DefaultHomeCoordinator {
  @objc func didTapBookmarkButton() {
    navigationBarDelegate?.didTapBookmarkButton()
    bookmarkButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
    favoriteButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
  }
  @objc func didTapFavoriteButton() {
    navigationBarDelegate?.didTapFavoriteButton()
    bookmarkButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    favoriteButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
  }
}
