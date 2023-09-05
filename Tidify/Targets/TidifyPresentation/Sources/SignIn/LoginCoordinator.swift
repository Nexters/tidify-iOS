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
  var parentCoordinator: Coordinator? { get set }
  
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
    navigationController.viewControllers = [getViewController()]
  }

  func didSuccessLogin() {
    guard let tabBarCoordinator = DIContainer.shared.resolve(type: TabBarCoordinator.self)
            as? DefaultTabBarCoordinator else { return }
    addChild(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultLoginCoordinator {
  func getViewController() -> LoginViewController {
    let useCase: UserUseCase = DIContainer.shared.resolve(type: UserUseCase.self)!
    let viewModel: LoginViewModel = .init(useCase: useCase)
    let viewController: LoginViewController = .init(
      viewModel: viewModel,
      coordinator: self
    )

    return viewController
  }
}
