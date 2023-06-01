//
//  SignInCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol SignInCoordinator: Coordinator {
  var parentCoordinator: Coordinator? { get set }
  
  func didSuccessSignIn()
}

final class DefaultSignInCoordinator: SignInCoordinator {

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

  func didSuccessSignIn() {
    guard let tabBarCoordinator = DIContainer.shared.resolve(type: TabBarCoordinator.self)
            as? DefaultTabBarCoordinator else { return }
    addChild(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultSignInCoordinator {
  func getViewController() -> SignInViewController {
    guard let useCase: SignInUseCase = DIContainer.shared.resolve(type: SignInUseCase.self)
    else { fatalError() }

    let reactor: SignInReactor = .init(coordinator: self,useCase: useCase)
    let viewController: SignInViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
