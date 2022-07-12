//
//  SignInCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import UIKit

protocol SignInCoordinator: Coordinator {
  func didSuccessSignInWithKakao()
  func didSuccessSingInWithApple()
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

  func start() {
    navigationController.pushViewController(getViewController(), animated: true)
  }

  func didSuccessSignInWithKakao() {
    var mainCoordinator: MainCoordinator?

    if let parentCoordinator = parentCoordinator as? MainCoordinator {
      // startWithSignIn으로 분기한 경우
      mainCoordinator = parentCoordinator
    } else {
      // startWithOnboarding으로 분기한 경우
      guard let onboardingCoordinator = parentCoordinator as? DefaultOnboardingCoordinator,
            let parentCoordinator = onboardingCoordinator.parentCoordinator
              as? MainCoordinator else { return }
      mainCoordinator = parentCoordinator
    }

    mainCoordinator?.start()
  }

  func didSuccessSingInWithApple() {
    // 추후 연동 진행
    print("⚠️ [Ian] \(#file) - \(#line): \(#function): Apple Login")
  }
}

private extension DefaultSignInCoordinator {
  func getViewController() -> SignInViewController {
    let viewModel: SignInViewModel = .init(dependencies: .init(coordinator: self))
    let viewController: SignInViewController = .init(viewModel: viewModel)

    return viewController
  }
}
