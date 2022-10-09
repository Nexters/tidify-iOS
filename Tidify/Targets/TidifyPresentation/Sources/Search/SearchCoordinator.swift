//
//  SearchCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol SearchCoordinator: Coordinator {}

final class DefaultSearchCoordinator: SearchCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let viewController: SearchViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    return getViewController()
  }
}

private extension DefaultSearchCoordinator {
  func getViewController() -> SearchViewController {
    guard let useCase: SearchUseCase = DIContainer.shared.resolve(type: SearchUseCase.self) else {
      fatalError()
    }

    let reactor: SearchReactor = .init(coordinator: self, useCase: useCase)
    let viewController: SearchViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
