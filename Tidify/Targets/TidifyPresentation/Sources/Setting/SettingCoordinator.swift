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
  func start() {
    let viewController: SettingViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}

private extension DefaultSettingCoordinator {
  func getViewController() -> SettingViewController {
//    navigationController.navigationBar.topItem?.title = ""
//    guard let useCase: SettingUseCase = DIContainer.shared.resolve(type: SettingUseCase.self) else {
//      fatalError()
//    }
//    let reactor: SettingReactor = .init(useCase: useCase, coordinator: self)
//    let viewController: SettingViewController = .init()
//    viewController.reactor = reactor
//
//    return viewController
    return .init()
  }
}
