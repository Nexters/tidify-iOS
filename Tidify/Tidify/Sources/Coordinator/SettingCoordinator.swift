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
    let backButton = UIButton().then {
      $0.setImage(R.image.nav_icon_back(), for: .normal)
    }

    let settingViewModel = SettingViewModel()
    let settingViewController = SettingViewController(viewModel: settingViewModel,
                                                      leftButton: backButton)
    settingViewController.coordinator = self

    backButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.navigationController.popViewController(animated: true)
      })
      .disposed(by: disposeBag)
    navigationController.pushViewController(settingViewController, animated: true)
  }
}

extension SettingCoordinator {
  func goToProfile() {
    let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
    profileCoordinator.parentCoordinator = self
    addChild(profileCoordinator)
    profileCoordinator.start()
  }

  func goToSocialLogin() {
    print("GoToSocialLogin Tapped")
  }
}
