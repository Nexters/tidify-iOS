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
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(mainViewModel)
        mainViewController.coordinator = self
        mainViewController.title = R.string.localizable.mainTitle()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .never  // 하위 뷰에서는 비활성화
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.isHidden = true
        navigationController.setViewControllers([mainViewController], animated: true)
    }

    func pushWebView() {
        let webViewController = WebViewController()
        webViewController.coordinator = self

        navigationController.pushViewController(webViewController, animated: true)
    }

    func presentSignIn() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(signInViewModel)
        signInViewController.coordinator = self

        navigationController.pushViewController(signInViewController, animated: true)
    }

    func pushRegisterView() {
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(registerViewModel)
        registerViewController.coordinator = self
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButtonItem.tintColor = UIColor.t_tidiBlue()
        self.navigationController.navigationItem.backBarButtonItem = backButtonItem
        navigationController.pushViewController(registerViewController, animated: true)
    }
}
