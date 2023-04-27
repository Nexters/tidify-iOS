//
//  DetailWebCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

protocol DetailWebCoordinator: Coordinator {}

final class DefaultDetailWebCoordinator: DetailWebCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  var bookmark: Bookmark?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let detailWebViewController: DetailWebViewController = .init(bookmark: bookmark!)
    navigationController.navigationBar.isHidden = false
    navigationController.pushViewController(detailWebViewController, animated: true)
  }
}
