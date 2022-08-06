//
//  MainCoordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public protocol MainCoordinator: Coordinator {
  func start()
}

public final class DefaultMainCoordiator: MainCoordinator {

  // MARK: Properties
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController

  let window: UIWindow

  // MARK: Initialize
  public init(window: UIWindow) {
    self.navigationController = UINavigationController()
    self.navigationController.view.backgroundColor = .systemBackground

    window.rootViewController = navigationController
    window.makeKeyAndVisible()
    self.window = window
  }

  // MARK: Methods
  public func start() {

  }
}

private extension DefaultMainCoordiator {
  func startOnboarding() {
    // TODO: Implementation
  }
  func startSignIn() {
    // TODO: Implementation
  }
}
