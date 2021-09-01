//
//  OnboardingViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import Foundation
import RxCocoa
import RxSwift

protocol OnboardingViewModelDelegate: AnyObject {
    func showNextPage()
}

class OnboardingViewModel: ViewModelType {
    struct Input {
        let nextButtonTap: Driver<Void>
        let currentPage: Driver<Int>
    }

    struct Output {
        let didTapNextButton: Driver<Void>
    }

    var onboardingDataSource: [Onboarding] {
        return setOnboardingResource()
    }

    weak var delegate: OnboardingViewModelDelegate?

    func transform(_ input: Input) -> Output {
        let didTapNextButton = input.nextButtonTap
            .withLatestFrom(input.currentPage)
            .filter { [weak self] index in
                guard let strongSelf = self else {
                    return false
                }

                if index < strongSelf.onboardingDataSource.count - 1 {
                    return true
                } else {
                    UserDefaults.standard.setValue(true, forKey: "didOnboarded")
                    self?.delegate?.showNextPage()
                    return false
                }
            }
            .map { _ in }

        return Output(didTapNextButton: didTapNextButton)
    }
}

private extension OnboardingViewModel {
    func setOnboardingResource() -> [Onboarding] {
        let dataSource = [
            Onboarding(title: R.string.localizable.onboardingTitle1(),
                       description: R.string.localizable.onboardingDesc1(),
                       image: R.image.tidify_logo()!,
                       buttonTitle: R.string.localizable.onboardingButtonTitle1()),
            Onboarding(title: R.string.localizable.onboardingTitle2(),
                       description: R.string.localizable.onboardingDesc2(),
                       image: R.image.tidify_logo()!,
                       buttonTitle: R.string.localizable.onboardingButtonTitle2()),
            Onboarding(title: R.string.localizable.onboardingTitle3(),
                       description: R.string.localizable.onboardingDesc3(),
                       image: R.image.tidify_logo()!,
                       buttonTitle: R.string.localizable.onboardingButtonTitle3()),
            Onboarding(title: R.string.localizable.onboardingTitle4(),
                       description: R.string.localizable.onboardingDesc4(),
                       image: R.image.tidify_logo()!,
                       buttonTitle: R.string.localizable.onboardingButtonTitle4()),
            Onboarding(title: R.string.localizable.onboardingTitle5(),
                       description: R.string.localizable.onboardingDesc5(),
                       image: R.image.tidify_logo()!,
                       buttonTitle: R.string.localizable.onboardingButtonTitle5())
        ]

        return dataSource
    }
}
