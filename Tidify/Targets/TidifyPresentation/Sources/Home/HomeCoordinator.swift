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

protocol HomeCoordinator: Coordinator {
  func pushWebView(bookmark: Bookmark)
  func pushProfileScene()
  func pushBookmarkCreationScene()
}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  private let navigationBar: TidifyNavigationBar!

  private let profileButton: UIButton = .init().then {
    $0.setImage(.init(named: "profileIcon"), for: .normal)
  }

  private let createBookmarkButton: UIButton = .init().then {
    $0.setImage(.init(named: "createBookMarkIcon"), for: .normal)
    $0.frame = .init(x: 0, y: 0, width: 78, height: 40)
  }

  // MARK: - Constructor
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController

    self.navigationBar = .init(
      .home,
      leftButton: profileButton,
      rightButton: createBookmarkButton
    )
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
    // TODO: Implementation
  }

  func pushProfileScene() {
    // TODO: Implementation
  }

  func pushBookmarkCreationScene() {
    // TODO: Implementation
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func getViewController() -> HomeViewController {
    guard let usecase: HomeUseCase = DIContainer.shared.resolve(type: HomeUseCase.self) else {
      fatalError()
    }

    let reactor: HomeReactor = .init(coordinator: self, useCase: usecase)
    let viewController: HomeViewController = .init(navigationBar)
    viewController.reactor = reactor

    return viewController
  }
}
