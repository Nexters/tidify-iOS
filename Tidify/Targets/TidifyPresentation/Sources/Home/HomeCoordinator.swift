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

import RxSwift

protocol HomeCoordinator: Coordinator {
  func pushWebView(bookmark: Bookmark)
  func pushSettingScene()
  func pushBookmarkCreationScene()
  func pushEditBookmarkScene(bookmark: Bookmark)
}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initializer
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let viewController: HomeViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    return getViewController()
  }

  func pushWebView(bookmark: Bookmark) {
    guard let detailWebViewCoordinator = DIContainer.shared.resolve(type: DetailWebCoordinator.self)
            as? DefaultDetailWebCoordinator else { return }

    detailWebViewCoordinator.parentCoordinator = self
    detailWebViewCoordinator.bookmark = bookmark
    addChild(detailWebViewCoordinator)

    detailWebViewCoordinator.start()
  }

  func pushSettingScene() {
    guard let settingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self)
            as? DefaultSettingCoordinator else { return }
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    settingCoordinator.start()
  }

  func pushBookmarkCreationScene() {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    bookmarkCreationCoordinator.start()
  }

  func pushEditBookmarkScene(bookmark: Bookmark) {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    //TODO: 구현 예정
//    bookmarkCreationCoordinator.pushEditBookmarkScene(with: bookmark)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func getViewController() -> HomeViewController {
    guard let fetchUseCase = DIContainer.shared.resolve(type: FetchBookmarkListUseCase.self),
          let searchUseCase = DIContainer.shared.resolve(type: SearchUseCase.self) else {
      fatalError()
    }

    let viewModel = HomeViewModel(fetchUseCase: fetchUseCase, searchUseCase: searchUseCase)
    let viewController = HomeViewController(viewModel: viewModel)
    viewController.coordinator = self

    return viewController
  }
}
