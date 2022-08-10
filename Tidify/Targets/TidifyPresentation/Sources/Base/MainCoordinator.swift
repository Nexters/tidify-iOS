//
//  MainCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public protocol MainCoordinator: Coordinator {
  func start()
}

public final class DefaultMainCoordinator: MainCoordinator {

  // MARK: - Properties
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  private let didOnboard: Bool = UserDefaults.standard.bool(forKey: "didOnboard")

  // MARK: - Initialize
  public init(window: UIWindow) {
    self.navigationController = .init(nibName: nil, bundle: nil)
    self.navigationController.view.backgroundColor = .systemBackground

    window.rootViewController = navigationController
  }

  // MARK: - Methods
  public func start() {
    if !didOnboard {
      startOnboarding()
    }
  }
}

private extension DefaultMainCoordinator {
  func startOnboarding() {
    let onboardingCoordinator: DefaultOnboardingCoordinator = .init(
      navigationController: navigationController
    )
    onboardingCoordinator.parentCoordinator = self
    addChild(onboardingCoordinator)

    onboardingCoordinator.start()
  }

  func startSignIn() {
    // TODO: Implementation
  }
  
  func startTabBar() {
    let tabBarCoordinator: DefaultTabBarCoordinator = .init(
      navigationController: navigationController
    )
    tabBarCoordinator.parentCoordinator = self
    addChild(tabBarCoordinator)
    
    tabBarCoordinator.start()
  }
}
