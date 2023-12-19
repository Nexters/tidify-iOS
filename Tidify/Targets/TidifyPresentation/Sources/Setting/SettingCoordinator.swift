//
//  SettingCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol SettingCoordinator: Coordinator {}

final class DefaultSettingCoordinator: SettingCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initializer
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {}

  func startPush() -> SettingViewController{
    guard let useCase: UserUseCase = DIContainer.shared.resolve(type: UserUseCase.self) else {
      fatalError()
    }

    let viewModel: SettingViewModel = .init(useCase: useCase)
    let viewController: SettingViewController = .init(viewModel: viewModel)
    viewController.coordinator = self

    return viewController
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  func resetCoordinator() {
    guard !(parentCoordinator is MainCoordinator) else {
      return
    }
    parentCoordinator = parentCoordinator?.parentCoordinator
    resetCoordinator()
  }
}
