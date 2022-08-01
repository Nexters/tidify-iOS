//
//  OnboardingCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
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
  private var accessToken = UserDefaultManager.accessToken

  // MARK: - Initialize

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    navigationController.pushViewController(getViewController(), animated: false)
  }

  func showNextScene() {
    UserDefaultManager.didOnboarded = true

    if accessToken != "" {
      Environment.shared.authorization = accessToken
      startTabBarController()
    } else {
      startSignInViewController()
    }
  }
}

private extension DefaultOnboardingCoordinator {
  func getViewController() -> OnboardingViewController {
    let reactor: OnboardingReactor = .init(coordinator: self)
    let viewController: OnboardingViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }

  func startTabBarController() {
    let tabBarCoordinator = DefaultTabBarCoordinator(navigationController: navigationController)
    tabBarCoordinator.parentCoordinator = self
    addChild(tabBarCoordinator)

    tabBarCoordinator.start()
  }

  func startSignInViewController() {
    let signInCoordinator = DefaultSignInCoordinator(navigationController: navigationController)
    signInCoordinator.parentCoordinator = self
    addChild(signInCoordinator)

    signInCoordinator.start()
  }
}
