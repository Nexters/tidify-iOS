//
//  SettingCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol SettingCoordinator: Coordinator {
  func pushSocialLoginSettingScene()
}

final class DefaultSettingCoordinator: SettingCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Constructor
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let viewController: SettingViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }

  func pushSocialLoginSettingScene() {
    // TODO: Implementation
  }
}

private extension DefaultSettingCoordinator {
  func getViewController() -> SettingViewController {
    navigationController.navigationBar.topItem?.title = ""
    let reactor: SettingReactor = .init(coordinator: self)
    let viewController: SettingViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
