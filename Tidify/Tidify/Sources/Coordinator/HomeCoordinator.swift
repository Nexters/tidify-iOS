//
//  HomeCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/12.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        let homewViewController = HomeViewController(viewModel: homeViewModel)
        homewViewController.coordinator = self

        let profileButton = UIButton()
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        profileButton.setTitle("이미지", for: .normal)
        profileButton.setTitleColor(.t_tidiBlue(), for: .normal)
        profileButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.pushSettingView()
            })
            .disposed(by: disposeBag)

        navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
        navigationController.setViewControllers([homewViewController], animated: true)
    }
}

// MARK: - 1 Depth
extension HomeCoordinator: HomeViewModelDelegate {
    func pushRegisterView() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.append(registerCoordinator)

        registerCoordinator.start()
    }

    func pushWebView() {
        let webViewCoordinator = WebViewCoordinator(navigationController: navigationController)
        webViewCoordinator.parentCoordinator = self
        childCoordinators.append(webViewCoordinator)

        webViewCoordinator.start()
    }
}

extension HomeCoordinator {
    func pushSettingView() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.parentCoordinator = self
        childCoordinators.append(settingCoordinator)

        settingCoordinator.start()
    }
}
