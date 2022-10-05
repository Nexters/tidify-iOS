//
//  SearchCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol SearchCoordinator: Coordinator {}

final class DefaultSearchCoordinator: SearchCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let searchViewController: SearchViewController = .init(nibName: nil, bundle: nil)
    navigationController.pushViewController(searchViewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    let searchReactor: SearchReactor = .init(coordinator: self)
    let searchViewController: SearchViewController = .init(nibName: nil, bundle: nil)
    searchViewController.reactor = searchReactor
    
    return searchViewController
  }
}
