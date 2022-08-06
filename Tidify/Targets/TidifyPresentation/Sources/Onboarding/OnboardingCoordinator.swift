//
//  OnboardingCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol OnboardingCoordinator: Coordinator {
  func showNextScene()
}

final class DefaultOnboardingCoordinator: OnboardingCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    navigationController.pushViewController(getViewController(), animated: true)
  }

  func showNextScene() {
    // TODO: Implementation
  }
}

private extension DefaultOnboardingCoordinator {
  func getViewController() -> OnboardingViewController {
    let reactor: OnboardingReactor = .init(coordinator: self)
    let viewController: OnboardingViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
