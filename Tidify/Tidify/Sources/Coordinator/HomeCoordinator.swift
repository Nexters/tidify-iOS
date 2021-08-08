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

    // MARK: - Constants

    static let navButtonHeight: CGFloat = 44
    static let createBookMarkButtonWidth: CGFloat = 75

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
        let homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.coordinator = self

        let profileButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.navButtonHeight, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_profile(), for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = Self.navButtonHeight / 2
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 0.8
            $0.layer.shadowOffset = CGSize(w: 0, h: 2)
            $0.layer.shadowRadius = Self.navButtonHeight / 2
            $0.layer.masksToBounds = false
        }

        let createBookMarkButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.createBookMarkButtonWidth, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_bookMark(), for: .normal)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = Self.navButtonHeight / 2
        }

        profileButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushSettingView()
            })
            .disposed(by: disposeBag)

        createBookMarkButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushRegisterView()
            })
            .disposed(by: disposeBag)

        homeViewController.t_setupNavigationBarButton(directionType: .left, button: profileButton)
        homeViewController.t_setupNavigationBarButton(directionType: .right, button: createBookMarkButton)

        navigationController.pushViewController(homeViewController, animated: true)
    }

    func startPush() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.coordinator = self

        let profileButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.navButtonHeight, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_profile(), for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = Self.navButtonHeight / 2
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 0.8
            $0.layer.shadowOffset = CGSize(w: 0, h: 2)
            $0.layer.shadowRadius = Self.navButtonHeight / 2
            $0.layer.masksToBounds = false
        }

        let createBookMarkButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.createBookMarkButtonWidth, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_bookMark(), for: .normal)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = Self.navButtonHeight / 2
        }

        profileButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushSettingView()
            })
            .disposed(by: disposeBag)

        createBookMarkButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushRegisterView()
            })
            .disposed(by: disposeBag)

        homeViewController.t_setupNavigationBarButton(directionType: .left, button: profileButton)
        homeViewController.t_setupNavigationBarButton(directionType: .right, button: createBookMarkButton)

        navigationController.setViewControllers([homeViewController], animated: true)
    }

    func show() {
        let profileButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.navButtonHeight, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_profile(), for: .normal)
            $0.backgroundColor = .white
            $0.layer.cornerRadius = Self.navButtonHeight / 2
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 0.8
            $0.layer.shadowOffset = CGSize(w: 0, h: 2)
            $0.layer.shadowRadius = Self.navButtonHeight / 2
            $0.layer.masksToBounds = false
        }

        let createBookMarkButton = UIButton().then {
            $0.frame = CGRect(x: 0, y: 0, width: Self.createBookMarkButtonWidth, height: Self.navButtonHeight)
            $0.setImage(R.image.home_icon_bookMark(), for: .normal)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = Self.navButtonHeight / 2
        }

        profileButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushSettingView()
            })
            .disposed(by: disposeBag)

        createBookMarkButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushRegisterView()
            })
            .disposed(by: disposeBag)

        parentCoordinator?.navigationController.visibleViewController?.t_setupNavigationBarButton(directionType: .left, button: profileButton)
        parentCoordinator?.navigationController.visibleViewController?.t_setupNavigationBarButton(directionType: .right, button: createBookMarkButton)
    }

    func hide() {
        parentCoordinator?.navigationController.visibleViewController?.navigationItem.leftBarButtonItem = nil
        parentCoordinator?.navigationController.visibleViewController?.navigationItem.rightBarButtonItem = nil
    }
}

// MARK: - 1 Depth

extension HomeCoordinator: HomeViewModelDelegate {
    func pushRegisterView() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.append(registerCoordinator)
        TabBarManager.shared.hideTabBarSubject.onNext(())

        registerCoordinator.start()
    }

    func pushWebView() {
        let webViewCoordinator = WebViewCoordinator(navigationController: navigationController)
        webViewCoordinator.parentCoordinator = self
        childCoordinators.append(webViewCoordinator)
        TabBarManager.shared.hideTabBarSubject.onNext(())

        webViewCoordinator.start()
    }
}

extension HomeCoordinator {
    func pushSettingView() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.parentCoordinator = self
        childCoordinators.append(settingCoordinator)
        TabBarManager.shared.hideTabBarSubject.onNext(())

        settingCoordinator.start()
    }
}
