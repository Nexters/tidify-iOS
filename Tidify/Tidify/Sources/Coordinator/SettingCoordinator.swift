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
                self?.navigationController.navigationBar.prefersLargeTitles = false
                self?.navigationController.popViewController(animated: true)
                TabBarManager.shared.showTabBarSubject.onNext(())
            })
            .disposed(by: disposeBag)

        settingViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.backgroundColor = .white
        settingViewController.title = R.string.localizable.settingNavigationTitle()
        navigationController.pushViewController(settingViewController, animated: true)
    }
}

extension SettingCoordinator {
    func goToProfile() {
        let profileViewController = ProfileViewController()
        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }
        let registerButton = UIButton().then {
            $0.setTitle("저장", for: .normal)
            $0.setTitleColor(.t_tidiBlue(), for: .normal)
        }

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                // 이미지, 이름 등록 로직 작성
                self?.navigationController.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        profileViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        profileViewController.t_setupNavigationBarButton(directionType: .right, button: registerButton)
        navigationController.title = "프로필"

        navigationController.pushViewController(profileViewController, animated: true)
    }

    func goToSocialLogin() {
        print("GoToSocialLogin Tapped")
    }
}
