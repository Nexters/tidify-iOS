//
//  MainCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import WebKit

class MainCoordinator: NSObject, Coordinator {

    // MARK: - Properties

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let window: UIWindow

    // MARK: - Initialize

    init(window: UIWindow) {
        self.window = window
        window.makeKeyAndVisible()
        self.navigationController = UINavigationController()
    }

    // MARK: - Methods

    func start() {
        window.rootViewController = navigationController
        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)

        homeCoordinator.start()
    }

    func startWithSignIn() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewController.coordinator = self

        navigationController.pushViewController(signInViewController, animated: true)
    }
}
