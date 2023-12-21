//
//  LoginCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol LoginCoordinator: Coordinator {
  func didSuccessLogin()
}

final class DefaultLoginCoordinator: LoginCoordinator {

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
    let vc = getViewController()
    navigationController.setViewControllers([vc], animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  func didSuccessLogin() {
    guard let tabBarCoordinator = DIContainer.shared.resolve(type: TabBarCoordinator.self)
            as? DefaultTabBarCoordinator else { return }
    tabBarCoordinator.parentCoordinator = parentCoordinator
    parentCoordinator?.addChild(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultLoginCoordinator {
  func getViewController() -> LoginViewController {
    guard let useCase = DIContainer.shared.resolve(type: UserUseCase.self) else {
      fatalError()
    }
    let viewModel = LoginViewModel(useCase: useCase)
    let viewController = LoginViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
