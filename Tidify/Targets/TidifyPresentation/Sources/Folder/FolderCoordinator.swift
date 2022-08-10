//
//  FolderCoordinator.swift
//  TidifyDataTests
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol FolderCoordinator: Coordinator {}

final class DefaultFolderCoordinator: FolderCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {
    let folderViewController: FolderViewController = .init(nibName: nil, bundle: nil)
    folderViewController.coordinator = self
    navigationController.pushViewController(folderViewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    let folderViewController: FolderViewController = .init(nibName: nil, bundle: nil)
    folderViewController.coordinator = self
    
    return folderViewController
  }
}
