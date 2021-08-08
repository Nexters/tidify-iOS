//
//  SettingCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SettingCoordinator: Coordinator {

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
        let settingViewModel = SettingViewModel()
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        settingViewController.coordinator = self

        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
                TabBarManager.shared.showTabBarSubject.onNext(())
            })
            .disposed(by: disposeBag)

        settingViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        navigationController.pushViewController(settingViewController, animated: true)
    }
}

extension SettingCoordinator {
    func goToProfile() {

    }

    func goToInterLink() {

    }

    func gotoAuthMethod() {

    }
}
