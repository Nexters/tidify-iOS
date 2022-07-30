//
//  OnboardingCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import UIKit

protocol OnboardingCoordinator: Coordinator {
  func showNextPage()
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

  func start() {
    navigationController.pushViewController(getViewController(), animated: false)
  }

  func showNextPage() {
    if let accessToken = UserDefaults.standard.string(forKey: "access_token") {
      Environment.shared.authorization = accessToken
      let tabBarCoordinator: DefaultTabBarCoordinator = .init(
        navigationController: navigationController
      )
      tabBarCoordinator.parentCoordinator = self
      addChild(tabBarCoordinator)

      tabBarCoordinator.start()
    } else {
      let signInCoordinator: DefaultSignInCoordinator = .init(
        navigationController: navigationController
      )
      signInCoordinator.parentCoordinator = self
      addChild(signInCoordinator)

      signInCoordinator.start()
    }
  }
}

private extension DefaultOnboardingCoordinator {
  func getViewController() -> OnboardingViewController {
    let reactor: OnboardingReactor = .init(coordinator: self)
    let viewController: OnboardingViewController = .init(reactor: reactor)

    return viewController
  }
}
