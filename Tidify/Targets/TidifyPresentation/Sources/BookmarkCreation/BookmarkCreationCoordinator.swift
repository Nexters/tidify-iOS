//
//  BookmarkCreationCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol BookmarkCreationCoordinator: Coordinator {
  func presentFolderSelectionScene()
  func close()
}

final class DefaultBookmarkCreationCoordinator: BookmarkCreationCoordinator {

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
    let viewController: BookmarkCreationViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }

  // TODO: Implementation
  func presentFolderSelectionScene() {
  }

  func close() {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - Private
private extension DefaultBookmarkCreationCoordinator {
  func getViewController() -> BookmarkCreationViewController {
    guard let usecase: BookmarkUseCase = DIContainer.shared.resolve(type: BookmarkUseCase.self) else {
      fatalError()
    }
    navigationController.navigationBar.topItem?.title = ""
    let reactor: BookmarkCreationReactor = .init(coordinator: self, useCase: usecase)
    let viewController: BookmarkCreationViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
