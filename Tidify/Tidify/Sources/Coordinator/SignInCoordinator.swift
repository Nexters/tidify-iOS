//
//  SignInCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import Foundation
import UIKit

class SignInCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    // MARK: - Initialize

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)

        navigationController.pushViewController(signInViewController, animated: true)
    }
}
