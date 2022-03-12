//
//  SignInCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import Foundation
import UIKit

final class SignInCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController

    // MARK: - Initialize

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let signInViewModel = SignInViewModel()
        signInViewModel.delegate = self
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewController.coordinator = parentCoordinator as? MainCoordinator

        navigationController.pushViewController(signInViewController, animated: true)
    }
}

extension SignInCoordinator: SignInViewModelDelegate {
    func didSuccessSignInWithKakao() {
        var mainCoordinator: MainCoordinator?

        if let parentCoordinator = parentCoordinator as? MainCoordinator {
            // startWithSignIn으로 분기한 경우
            mainCoordinator = parentCoordinator
        } else {
            // startWithOnboarding으로 분기한 경우
            let onboardingCoordinator = parentCoordinator as? OnboardingCoordinator
            let parentCoordinator = onboardingCoordinator?.parentCoordinator as? MainCoordinator

            mainCoordinator = parentCoordinator
        }

        mainCoordinator?.start()
    }

    func didSUccessSingInWithApple() {
        // 추후 연동 진행
        print("⚠️ [Ian] \(#file) - \(#line): \(#function): Apple Login")
    }
}
