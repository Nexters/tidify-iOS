//
//  FolderCoordinator.swift
//  TidifyPresentation
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
  
  private let profileButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "profileIcon"), for: .normal)
  }
  
  private let createButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "createFolderIcon"), for: .normal)
  }
  
  private let navigationBar: TidifyNavigationBar?

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.navigationBar = TidifyNavigationBar(
      .folder,
      leftButton: profileButton,
      rightButton: createButton
    )
  }

  // MARK: - Methods
  func start() {
    guard let navigationBar = navigationBar else { return }
    let folderViewController: FolderViewController = .init(navigationBar)
    folderViewController.coordinator = self
    
    navigationController.pushViewController(folderViewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    guard let navigationBar = navigationBar else { return UIViewController.init() }
    let folderViewController: FolderViewController = .init(navigationBar)
    folderViewController.coordinator = self
    
    return folderViewController
  }
}
