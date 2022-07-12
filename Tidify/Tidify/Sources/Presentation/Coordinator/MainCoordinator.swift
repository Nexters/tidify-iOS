//
//  MainCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import UIKit
import WebKit

protocol MainCoordinator: Coordinator {
  func startWithOnboarding()
  func startWithSignIn()
}

final class DefaultMainCoordinator: NSObject, MainCoordinator {

  // MARK: - Properties

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  let window: UIWindow

  // MARK: - Initialize

  init(window: UIWindow) {
    self.window = window
    self.window.makeKeyAndVisible()

    self.navigationController = UINavigationController()
    self.window.rootViewController = navigationController
    self.navigationController.navigationBar.isHidden = true
    self.navigationController.view.backgroundColor = .systemBackground
  }

  // MARK: - Methods

  func start() {
    let tabBarCoordinator: DefaultTabBarCoordinator = .init(
      navigationController: navigationController
    )
    tabBarCoordinator.parentCoordinator = self
    addChild(tabBarCoordinator)

    tabBarCoordinator.start()
  }

  func startWithOnboarding() {
    let onboardingCoordinator: DefaultOnboardingCoordinator = .init(
      navigationController: navigationController
    )
    onboardingCoordinator.parentCoordinator = self
    addChild(onboardingCoordinator)

    onboardingCoordinator.start()
  }

  func startWithSignIn() {
    let signInCoordinator: DefaultSignInCoordinator = .init(
      navigationController: navigationController
    )
    signInCoordinator.parentCoordinator = self
    addChild(signInCoordinator)

    signInCoordinator.start()
  }
}
