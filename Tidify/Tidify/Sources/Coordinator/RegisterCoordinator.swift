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

class RegisterCoordinator: Coordinator {

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
        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(
            viewModel: registerViewModel,
            title: R.string.localizable.mainAddBookMarkTitle(),
            leftButton: backButton
        )
        registerViewController.coordinator = self

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak registerViewController] in
                registerViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        registerViewController.navigationItem.title = R.string.localizable.mainAddBookMarkTitle()

        navigationController.pushViewController(registerViewController, animated: true)
    }

    func startPush() -> UIViewController {
        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let registerViewModel = RegisterViewModel()
        let registerViewController = RegisterViewController(
            viewModel: registerViewModel,
            title: R.string.localizable.mainAddBookMarkTitle(),
            leftButton: backButton
        )
        registerViewController.coordinator = self

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak registerViewController] in
                registerViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        return registerViewController
    }
}

extension RegisterCoordinator {
    func popRegisterVC() {
        navigationController.popViewController(animated: true)
    }
}
