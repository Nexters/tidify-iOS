//
//  OnboardingCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol OnboardingCoordinator: Coordinator {
  var parentCoordinator: Coordinator? { get set }

  func showNextScene()
  func startEmptyGuide()
}

final class DefaultOnboardingCoordinator: OnboardingCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  private var isEmptyGuide: Bool = false

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    navigationController.pushViewController(getViewController(), animated: true)
  }

  func startEmptyGuide() {
    isEmptyGuide = true
    start()
  }

  func showNextScene() {
    if isEmptyGuide {
      navigationController.popViewController(animated: true)
      return
    }
    let loginCoordinator: DefaultLoginCoordinator = .init(
      navigationController: navigationController
    )
    loginCoordinator.parentCoordinator = parentCoordinator
    parentCoordinator?.addChild(loginCoordinator)
    loginCoordinator.start()
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}

private extension DefaultOnboardingCoordinator {
  func getViewController() -> OnboardingViewController {
    let viewController: OnboardingViewController = .init(nibName: nil, bundle: nil)
    viewController.coordinator = self

    return viewController
  }
}
