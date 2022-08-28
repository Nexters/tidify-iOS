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
}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
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
    // TODO: Implementation
  }
}

// MARK: - Private
private extension HomeCoordinator {
  func getViewController() -> HomeViewController {
    guard let usecase: HomeUseCase = DIContainer.shared.resolve(type: HomeUseCase.self) else {
      fatalError()
    }

    let reactor: HomeReactor = .init(useCase: usecase)
    reactor.coordinator = self
    let viewController: HomeViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
