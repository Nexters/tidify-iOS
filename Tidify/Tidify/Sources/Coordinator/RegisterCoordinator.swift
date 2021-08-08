//
//  RegisterCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/12.
//

import Foundation
import UIKit

class RegisterCoordinator: TabChildCoordinator {

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
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(viewModel: registerViewModel)
        registerViewController.coordinator = self
        navigationController.navigationBar.isHidden = false

        navigationController.pushViewController(registerViewController, animated: true)
    }

    func startPush() {
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(viewModel: registerViewModel)
        registerViewController.coordinator = self

        navigationController.setViewControllers([registerViewController], animated: true)

        navigationController.isNavigationBarHidden = true
    }

    func show() {
        // do nothing yet..
    }

    func hide() {
        // do nothing yet..
    }
}
