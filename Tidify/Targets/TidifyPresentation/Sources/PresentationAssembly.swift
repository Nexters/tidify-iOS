//
//  PresentationAssembly.swift
//  Tidify
//
//  Created by Ian on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit


public struct PresentationAssembly: Assemblable {

  private let navigationController: UINavigationController

  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  public func assemble(container: DIContainer) {
    container.register(type: OnboardingCoordinator.self) { _ in
      DefaultOnboardingCoordinator(navigationController: navigationController)
    }

    container.register(type: SignInCoordinator.self) { _ in
      DefaultSignInCoordinator(navigationController: navigationController)
    }

    container.register(type: TabBarCoordinator.self) { _ in
      DefaultTabBarCoordinator(navigationController: navigationController)
    }

    container.register(type: HomeCoordinator.self) { _ in
      DefaultHomeCoordinator(navigationController: navigationController)
    }
  }
}
