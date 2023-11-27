//
//  FolderCreationCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/11/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol FolderCreationCoordinator: Coordinator {}

final class DefaultFolderCreationCoordinator: FolderCreationCoordinator {

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

  func startPush(type: CreationType, originFolder: Folder? = nil) -> FolderCreationViewController {
    guard let useCase: FolderUseCase = DIContainer.shared.resolve(type: FolderUseCase.self) else {
      fatalError()
    }

    let viewModel: FolderCreationViewModel = .init(useCase: useCase)
    let viewController: FolderCreationViewController = .init(
      viewModel: viewModel,
      creationType: type,
      originFolder: originFolder
    )
    viewController.coordinator = self

    return viewController
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }
}
