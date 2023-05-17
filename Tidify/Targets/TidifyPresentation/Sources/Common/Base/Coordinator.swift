//
//  Coordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

/// Protocol that all coordinator must be conform
public protocol Coordinator: AnyObject {

  // MARK: - Properties
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  // MARK: - Methods
  func start()
  func addChild(_ child: Coordinator)
}

// MARK: - Default Implementation
public extension Coordinator {
  func addChild(_ child: Coordinator) {
    childCoordinators.append(child)
  }

  func transitionToSignIn() {
    let signInCoordinator: SignInCoordinator = DIContainer.shared.resolve(type: SignInCoordinator.self)!
    signInCoordinator.start()
  }
}
