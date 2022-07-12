//
//  OnboardingCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import Foundation
import UIKit

class OnboardingCoordinator: Coordinator {

  // MARK: - Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []

  var navigationController: UINavigationController

  // MARK: - Initialize

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let onboardingViewModel = OnboardingViewModel()
    onboardingViewModel.delegate = self
    let onboardingViewController = OnboardingViewController(viewModel: onboardingViewModel)
    self.navigationController.pushViewController(onboardingViewController, animated: false)
  }
}

extension OnboardingCoordinator: OnboardingViewModelDelegate {
  func showNextPage() {
    if let accessToken = UserDefaults.standard.string(forKey: "access_token") {
      Environment.shared.authorization = accessToken
      let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
      tabBarCoordinator.parentCoordinator = self
      addChild(tabBarCoordinator)

      tabBarCoordinator.start()
    } else {
      let signInCoordinator = SignInCoordinator(navigationController: navigationController)
      signInCoordinator.parentCoordinator = self
      addChild(signInCoordinator)

      signInCoordinator.start()
    }
  }
}
