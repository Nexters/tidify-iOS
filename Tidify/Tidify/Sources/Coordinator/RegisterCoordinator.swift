//
//  RegisterCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/12.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class RegisterCoordinator: TabChildCoordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Methods

    func start() {
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(viewModel: registerViewModel)
        registerViewController.coordinator = self

        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak registerViewController] in
                registerViewController?.navigationController?.popViewController(animated: true)
                TabBarManager.shared.showTabBarSubject.onNext(())
            })
            .disposed(by: disposeBag)

        registerViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        registerViewController.navigationItem.title = R.string.localizable.mainAddBookMarkTitle()

        navigationController.pushViewController(registerViewController, animated: true)
    }

    func startPush() {
        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(viewModel: registerViewModel)
        registerViewController.coordinator = self

        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak registerViewController] in
                registerViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        registerViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        navigationController.setViewControllers([registerViewController], animated: true)
    }

    func show() {
        // do nothing yet..
    }

    func hide() {
        // do nothing yet..
    }

    func popRegisterVC() {
        navigationController.popViewController(animated: true)
    }
}
