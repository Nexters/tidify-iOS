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

  // MARK: - Properties
  private let navigationController: UINavigationController

  // MARK: - Initializer
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
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

    container.register(type: SettingCoordinator.self) { _ in
      DefaultSettingCoordinator(navigationController: navigationController)
    }

    container.register(type: BookmarkCreationCoordinator.self) { _ in
      DefaultBookmarkCreationCoordinator(navigationController: navigationController)
    }

    container.register(type: DetailWebCoordinator.self) { _ in
      DefaultDetailWebCoordinator(navigationController: navigationController)
    }

    container.register(type: SearchCoordinator.self) { _ in
      DefaultSearchCoordinator(navigationController: navigationController)
    }
  }
}
