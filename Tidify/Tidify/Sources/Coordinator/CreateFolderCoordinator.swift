//
//  CreateFolderCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class CreateFolderCoordinator: Coordinator {

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
            $0.setImage(R.image.nav_icon_back(), for: .normal)
        }

        let createFolderViewModel = CreateFolderViewModel()
        let createFolderViewController = CreateFolderViewController(
            viewModel: createFolderViewModel,
            leftButton: leftButton
        )
        createFolderViewController.coordinator = self

        leftButton.rx.tap.asDriver()
            .drive(onNext: { _ in
                createFolderViewController.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        navigationController.pushViewController(createFolderViewController, animated: true)
    }
}
