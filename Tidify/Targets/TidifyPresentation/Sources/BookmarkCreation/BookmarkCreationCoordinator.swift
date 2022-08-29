//
//  BookmarkCreationCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol BookmarkCreationCoordinator: Coordinator { }

final class DefaultBookmarkCreationCoordinator: BookmarkCreationCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Constructor
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let viewController: BookmarkCreationViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - Private
private extension DefaultBookmarkCreationCoordinator {
  func getViewController() -> BookmarkCreationViewController {
    let reactor: BookmarkCreationReactor = .init()
    let viewController: BookmarkCreationViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
