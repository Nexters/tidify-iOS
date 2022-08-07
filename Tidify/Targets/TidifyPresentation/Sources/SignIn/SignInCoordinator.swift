//
//  SignInCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

protocol SignInCoordinator: Coordinator {
  func didSuccessSignInWithKakao()
  func didSuccessSignInWithApple()
  func didSuccessSignInWithGoogle()
  func skipSignIn()
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
//    navigationController.pushViewController(getViewController(), animated: true)
  }

  func didSuccessSignInWithKakao() {
    // TODO: Implementation
  }

  func didSuccessSignInWithApple() {
    // TODO: Implementation
  }

  func didSuccessSignInWithGoogle() {
    // TODO: Implementation
  }

  func skipSignIn() {
    // TODO: Implementation
  }
}

// MARK: - Private
private extension DefaultSignInCoordinator {
  func getViewController() -> SignInViewController {
    let reactor: SignInReactor = .init(coordinator: self, usecase: DefaultSignInUseCase())
    let viewController: SignInViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
