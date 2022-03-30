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

  static let navButtonSize: CGFloat = 40
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
    let profileButton = UIButton().then {
      $0.frame = CGRect(x: 0, y: 0, width: Self.navButtonSize, height: Self.navButtonSize)
      $0.setImage(R.image.home_icon_profile(), for: .normal)
      $0.layer.borderColor = UIColor(hexString: "#3C3C43", alpha: 0.08).cgColor
      $0.layer.borderWidth = 1
      $0.t_cornerRadius(radius: Self.navButtonSize / 2)
    }

    let createBookMarkButton = UIButton().then {
      $0.frame = CGRect(
        x: 0,
        y: 0,
        width: Self.createBookMarkButtonWidth,
        height: Self.navButtonSize
      )
      $0.setImage(R.image.home_icon_bookMark(), for: .normal)
      $0.backgroundColor = .t_tidiBlue00()
      $0.layer.cornerRadius = Self.navButtonSize / 2
    }

    let homeViewModel = HomeViewModel()
    homeViewModel.delegate = self
    let homeViewController = HomeViewController(
      viewModel: homeViewModel,
      leftButton: profileButton,
      rightButton: createBookMarkButton
    )
    homeViewController.coordinator = self

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

    navigationController.pushViewController(homeViewController, animated: true)
  }

  func startPush() -> UIViewController {
    let profileButton = UIButton().then {
      $0.frame = CGRect(
        x: 0,
        y: 0,
        width: Self.navButtonSize,
        height: Self.navButtonSize
      )
      $0.setImage(R.image.home_icon_profile(), for: .normal)
      $0.layer.borderColor = UIColor(hexString: "#3C3C43", alpha: 0.08).cgColor
      $0.layer.borderWidth = 1
      $0.t_cornerRadius(radius: Self.navButtonSize / 2)
      $0.layer.masksToBounds = false
    }

    let createBookMarkButton = UIButton().then {
      $0.frame = CGRect(
        x: 0,
        y: 0,
        width: Self.createBookMarkButtonWidth,
        height: Self.navButtonSize
      )
      $0.setImage(R.image.home_icon_bookMark(), for: .normal)
      $0.backgroundColor = .t_tidiBlue00()
      $0.t_cornerRadius(radius: Self.navButtonSize / 2)
    }

    let homeViewModel = HomeViewModel()
    homeViewModel.delegate = self
    let homeViewController = HomeViewController(
      viewModel: homeViewModel,
      leftButton: profileButton,
      rightButton: createBookMarkButton
    )
    homeViewController.coordinator = self

    return homeViewController
  }
}

// MARK: - 1 Depth

extension HomeCoordinator: HomeViewModelDelegate {
  func pushRegisterView() {
    let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
    registerCoordinator.parentCoordinator = self
    addChild(registerCoordinator)

    registerCoordinator.start()
  }

  func pushWebView(_ url: String) {
    let webViewCoordinator = WebViewCoordinator(navigationController: navigationController,
                                                urlString: url)
    webViewCoordinator.parentCoordinator = self
    addChild(webViewCoordinator)

    webViewCoordinator.start()
  }
}

extension HomeCoordinator {
  func pushSettingView() {
    let settingCoordinator = SettingCoordinator(navigationController: navigationController)
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    settingCoordinator.start()
  }
}
