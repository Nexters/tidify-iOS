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
  func pushEditBookmarkScene(with bookmark: Bookmark)
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

  func close() {
    navigationController.popViewController(animated: true)
  }

  func pushEditBookmarkScene(with bookmark: Bookmark) {
    let viewController: BookmarkCreationViewController = getViewController(bookmark)
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - Private
private extension DefaultBookmarkCreationCoordinator {
  func getViewController(_ bookmark: Bookmark? = nil) -> BookmarkCreationViewController {
    guard let useCase: BookmarkCreationUseCase = DIContainer.shared.resolve(
      type: BookmarkCreationUseCase.self) else { fatalError() }
    navigationController.navigationBar.topItem?.title = ""
    let reactor: BookmarkCreationReactor = .init(coordinator: self, useCase: useCase, bookmark: bookmark)
    let viewController: BookmarkCreationViewController = .init(nibName: nil, bundle: nil)
    viewController.reactor = reactor

    return viewController
  }
}
