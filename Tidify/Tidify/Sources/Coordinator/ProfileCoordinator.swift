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
        let profileViewController = ProfileViewController(saveDataSubject)
        profileViewController.coordinator = self

        let backButton = UIButton().then {
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let registerButton = UIButton().then {
            $0.setTitle("저장", for: .normal)
            $0.setTitleColor(.t_tidiBlue(), for: .normal)
        }

        backButton.rx.tap.asDriver()
            .drive(onNext: { [weak profileViewController] _ in
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap.asDriver()
            .drive(onNext: { [weak self, weak profileViewController] _ in
                self?.saveDataSubject.onNext(())
                profileViewController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        profileViewController.t_setupNavigationBarButton(directionType: .left, button: backButton)
        profileViewController.t_setupNavigationBarButton(directionType: .right, button: registerButton)

        navigationController.pushViewController(profileViewController, animated: true)
    }
}
