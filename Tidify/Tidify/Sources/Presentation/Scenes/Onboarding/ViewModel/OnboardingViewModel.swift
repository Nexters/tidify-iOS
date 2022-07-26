//
//  OnboardingViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import Foundation

import RxCocoa
import RxSwift

final class OnboardingViewModel {

  struct Dependencies {
    let coordinator: OnboardingCoordinator
  }

  private let dependencies: Dependencies

  var currentPageRelay = BehaviorRelay<Int>(value: 0)

  var onboardingDataSource: [Onboarding] {
    setOnboardingResource()
  }

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}

extension OnboardingViewModel: ViewModelType {
  struct Input {
    let nextButtonTap: Observable<Void>
  }

  struct Output {
    let didTapNextButton: Observable<Void>
    let content: Observable<[Onboarding]>
    let currentPage: Observable<Int>
  }

  func transform(_ input: Input) -> Output {
    let didTapNextButton = input.nextButtonTap
      .do(onNext: { [weak self] in
        guard let self = self else { return }
        let currentValue = self.currentPageRelay.value

        if currentValue + 1 > self.onboardingDataSource.count - 1 {
          UserDefaults.standard.setValue(true, forKey: "didOnborded")
          self.dependencies.coordinator.showNextPage()
        } else {
          self.currentPageRelay.accept(currentValue + 1)
        }
      })

    return Output(didTapNextButton: didTapNextButton,
                  content: Observable.just(onboardingDataSource),
                  currentPage: currentPageRelay.asObservable()
    )
  }
}

private extension OnboardingViewModel {
  func setOnboardingResource() -> [Onboarding] {
    let dataSource = [
      Onboarding(image: R.image.onboarding_0()!,
                 buttonTitle: R.string.localizable.onboardingButtonTitle1()),
      Onboarding(image: R.image.onboarding_1()!,
                 buttonTitle: R.string.localizable.onboardingButtonTitle2()),
      Onboarding(image: R.image.onboarding_2()!,
                 buttonTitle: R.string.localizable.onboardingButtonTitle3()),
      Onboarding(image: R.image.onboarding_3()!,
                 buttonTitle: R.string.localizable.onboardingButtonTitle4())
    ]

    return dataSource
  }
}
