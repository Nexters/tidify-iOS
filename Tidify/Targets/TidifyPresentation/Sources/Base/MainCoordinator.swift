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
  func start()
}

public final class DefaultMainCoordinator: MainCoordinator {

  // MARK: - Properties
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  private let container: DIContainer = .shared
  private let didOnboard: Bool = UserDefaults.standard.bool(forKey: "didOnboard")

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    navigationController.view.backgroundColor = .systemBackground
    self.navigationController = navigationController
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
    guard let onboardingCoordinator = container.resolve(type: OnboardingCoordinator.self)
            as? DefaultOnboardingCoordinator else { return }

    onboardingCoordinator.parentCoordinator = self
    addChild(onboardingCoordinator)

    onboardingCoordinator.start()
  }

  func startSignIn() {
    guard let signInCoordinator = container.resolve(type: SignInCoordinator.self)
            as? DefaultSignInCoordinator else { return }

    signInCoordinator.parentCoordinator = self
    addChild(signInCoordinator)

    signInCoordinator.start()
  }
  
  func startTabBar() {
    guard let tabBarCoordinator = container.resolve(type: TabBarCoordinator.self)
            as? DefaultTabBarCoordinator else { return }

    tabBarCoordinator.parentCoordinator = self
    addChild(tabBarCoordinator)
    
    tabBarCoordinator.start()
  }
}
