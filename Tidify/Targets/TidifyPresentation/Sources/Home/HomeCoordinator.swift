//
//  HomeCoordinator.swift
//  TidifyDataTests
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol HomeCoordinator: Coordinator {}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let homeViewController: HomeViewController = .init(nibName: nil, bundle: nil)
    homeViewController.coordinator = self
    navigationController.pushViewController(homeViewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    let homeViewController: HomeViewController = .init(nibName: nil, bundle: nil)
    homeViewController.coordinator = self
    
    return homeViewController
  }
}
