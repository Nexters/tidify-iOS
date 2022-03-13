//
//  FolderTabCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class FolderTabCoordinator: Coordinator {

    // MARK: - Constants

    static let navButtonSize: CGFloat = 40

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
        let leftButton = UIButton().then {
            $0.setImage(R.image.home_icon_profile(), for: .normal)
        }

        let rightButton = UIButton().then {
            $0.setImage(R.image.nav_icon_createFolder(), for: .normal)
        }

        let folderTabViewModel = FolderTabViewModel()
        let folderTabViewController = FolderTabViewController(viewModel: folderTabViewModel,
                                                              leftButton: leftButton,
                                                              rightButton: rightButton)
        folderTabViewController.coordinator = self
        leftButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushSettingView()
            })
            .disposed(by: disposeBag)

        rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.pushCreateFolderView()
            })
            .disposed(by: disposeBag)
    }

    func startPush() -> UIViewController {
        let leftButton = UIButton().then {
            $0.frame = CGRect(
                x: 0,
                y: 0,
                width: Self.navButtonSize,
                height: Self.navButtonSize
            )
            $0.setImage(R.image.home_icon_profile(), for: .normal)
            $0.backgroundColor = .white
            $0.t_cornerRadius(radius: Self.navButtonSize / 2)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hexString: "#3C3C43", alpha: 0.08).cgColor
            $0.layer.masksToBounds = false
        }

        let rightButton = UIButton().then {
            $0.frame = CGRect(
                x: 0,
                y: 0,
                width: Self.navButtonSize,
                height: Self.navButtonSize
            )
            $0.setImage(R.image.nav_icon_createFolder(), for: .normal)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = Self.navButtonSize / 2
        }

        let folderTabViewModel = FolderTabViewModel()
        let folderTabViewController = FolderTabViewController(viewModel: folderTabViewModel,
                                                              leftButton: leftButton,
                                                              rightButton: rightButton)
        folderTabViewController.coordinator = self

        return folderTabViewController
    }
}

// MARK: - 1Depth

extension FolderTabCoordinator {
    func pushSettingView() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.parentCoordinator = self
        childCoordinators.append(settingCoordinator)

        settingCoordinator.start()
    }

    func pushCreateFolderView() {
        let folderCoordinator = CreateFolderCoordinator(navigationController: navigationController)
        folderCoordinator.parentCoordinator = self
        childCoordinators.append(folderCoordinator)

        folderCoordinator.start()
    }
}
