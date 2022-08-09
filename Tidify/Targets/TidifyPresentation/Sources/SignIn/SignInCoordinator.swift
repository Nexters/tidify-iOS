//
//  SignInCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyData
import TidifyDomain

import UIKit

protocol SignInCoordinator: Coordinator {
  func didSuccessSignIn(type: SocialLoginType)
}

final class DefaultSignInCoordinator: SignInCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    navigationController.viewControllers = [getViewController()]
  }

  func didSuccessSignIn(type: SocialLoginType) {
    // TODO: Implementation
  }
}

// MARK: - Private
private extension DefaultSignInCoordinator {
  func getViewController() -> SignInViewController {
    let reactor: SignInReactor = .init(
      coordinator: self,
      usecase: DefaultSignInUseCase(repository: DefaultSignInRepository())
    )
    let viewController: SignInViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
