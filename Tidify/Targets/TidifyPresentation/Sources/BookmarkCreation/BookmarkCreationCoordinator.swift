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

protocol BookmarkCreationCoordinator: Coordinator {}

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
  func start() {}

  func startPush(type: CreationType, originBookmark: Bookmark? = nil) -> BookmarkCreationViewController {
    guard let useCase: BookmarkCRUDUseCase = DIContainer.shared.resolve(type: BookmarkCRUDUseCase.self) else {
      fatalError()
    }

//    let viewModel: BookmarkCreationViewModel = .init(useCase: useCase)
//    let viewController: BookmarkCreationViewController = .init(
//      viewModel: viewModel,
//      creationType: type,
//      originBookmark: originBookmark
//    )
//    viewController.coordinator = self
//
//    return viewController

    //TODO: 구현 예정
    return .init(nibName: nil, bundle: nil)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }
}
