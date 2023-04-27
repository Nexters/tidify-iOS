//
//  MainCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

public protocol MainCoordinator: Coordinator {
  func startSplash()
}

public final class DefaultMainCoordinator: MainCoordinator {

  // MARK: - Properties
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  private let container: DIContainer = .shared

  private let isFirstLaunch: Bool = UserDefaultsStorage.isFirstLaunch

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    navigationController.view.backgroundColor = .systemBackground
    self.navigationController = navigationController
  }

  // MARK: - Methods
  public func startSplash() {
    let splashViewController: SplashViewController = .init(coordinator: self)
    navigationController.pushViewController(splashViewController, animated: false)
  }

  public func start() {
    navigationController.popViewController(animated: false)

    if isFirstLaunch {
      UserDefaultsStorage.isFirstLaunch = false
      KeyChain.deleteAll()
    }

    if KeyChain.load(key: .accessToken) != nil {
      startTabBar()
      return
    }

    isFirstLaunch ? startOnboarding() : startSignIn()
  }
}

private extension DefaultMainCoordinator {
  func startOnboarding() {
    guard let onboardingCoordinator = container.resolve(type: OnboardingCoordinator.self) else {
      return
    }

    onboardingCoordinator.parentCoordinator = self
    addChild(onboardingCoordinator)

    onboardingCoordinator.start()
  }

  func startSignIn() {
    guard let signInCoordinator = container.resolve(type: SignInCoordinator.self) else {
      return
    }

    signInCoordinator.parentCoordinator = self
    addChild(signInCoordinator)

    signInCoordinator.start()
  }
  
  func startTabBar() {
    guard let tabBarCoordinator = container.resolve(type: TabBarCoordinator.self) else {
      return
    }

    tabBarCoordinator.parentCoordinator = self
    addChild(tabBarCoordinator)
    
    tabBarCoordinator.start()
  }
}
