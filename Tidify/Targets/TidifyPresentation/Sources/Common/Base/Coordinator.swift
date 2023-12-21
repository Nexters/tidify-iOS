//
//  Coordinator.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import UIKit

protocol Coordinatable: AnyObject {
  associatedtype CoordinatorType: Coordinator

  var coordinator: CoordinatorType? { get }
}

/// Protocol that all coordinator must be conform
public protocol Coordinator: AnyObject {

  // MARK: - Properties
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  // MARK: - Methods
  func start()
  func didFinish()
}

// MARK: - Default Implementation
public extension Coordinator {
  func addChild(_ child: Coordinator) {
    childCoordinators.append(child)
  }

  func transitionToLogin() {
    let loginCoordinator: LoginCoordinator = DIContainer.shared.resolve(type: LoginCoordinator.self)!
    loginCoordinator.parentCoordinator = parentCoordinator
    addChild(loginCoordinator)
    KeyChain.deleteAll()
    loginCoordinator.start()
  }

  func removeChild(_ child: Coordinator?) {
    for (idx, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: idx)
        break
      }
    }
  }
}
