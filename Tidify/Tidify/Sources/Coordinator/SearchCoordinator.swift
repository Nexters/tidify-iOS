//
//  SearchCoordinator.swift
//  Tidify
//
//  Created by Ian on 2022/03/13.
//

import Foundation
import UIKit

final class SearchCoordinator: Coordinator {

  // MARK: - Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let searchViewModel = SearchViewModel()
    let searchViewController = SearchViewController(searchViewModel)

    navigationController.pushViewController(searchViewController, animated: true)
  }

  func startPush() -> UIViewController {
    let searchViewModel = SearchViewModel()
    let searchViewController = SearchViewController(searchViewModel)

    return searchViewController
  }
}
