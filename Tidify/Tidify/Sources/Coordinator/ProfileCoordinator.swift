//
//  ProfileCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/15.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class ProfileCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()
    private let saveDataSubject = PublishSubject<Void>()

    // MARK: - Initialize

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Methods

    func start() {
        let leftButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let rightButton = UIButton().then {
            $0.setTitle(R.string.localizable.profileNavButtonTitle(), for: .normal)
            $0.setTitleColor(.t_tidiBlue(), for: .normal)
        }

        let profileViewController = ProfileViewController(saveDataSubject,
                                                          leftButton: leftButton,
                                                          rightButton: rightButton)
        profileViewController.coordinator = self

        leftButton.rx.tap.asDriver()
            .drive(onNext: { [weak profileViewController] _ in
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self, weak profileViewController] _ in
                self?.saveDataSubject.onNext(())
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        navigationController.pushViewController(profileViewController, animated: true)
    }

    func startPush() -> UIViewController {
        let leftButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let rightButton = UIButton().then {
            $0.setTitle(R.string.localizable.profileNavButtonTitle(), for: .normal)
            $0.setTitleColor(.t_tidiBlue(), for: .normal)
        }

        let profileViewController = ProfileViewController(saveDataSubject,
                                                          leftButton: leftButton,
                                                          rightButton: rightButton)
        profileViewController.coordinator = self

        leftButton.rx.tap.asDriver()
            .drive(onNext: { [weak profileViewController] _ in
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        rightButton.rx.tap.asDriver()
            .drive(onNext: { [weak self, weak profileViewController] _ in
                self?.saveDataSubject.onNext(())
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        return profileViewController
    }
}
