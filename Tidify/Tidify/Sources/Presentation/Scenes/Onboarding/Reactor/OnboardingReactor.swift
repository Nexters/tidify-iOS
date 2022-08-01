//
//  OnboardingReactor.swift
//  Tidify
//
//  Created by Ian on 2022/07/30.
//

import ReactorKit

final class OnboardingReactor {

  // MARK: Properties
  private let coordinator: OnboardingCoordinator
  var initialState: State = .init(
    contents: [
      .init(image: R.image.onboarding_0()!,
            buttonTitle: R.string.localizable.onboardingButtonTitle1()),
      .init(image: R.image.onboarding_1()!,
            buttonTitle: R.string.localizable.onboardingButtonTitle2()),
      .init(image: R.image.onboarding_2()!,
            buttonTitle: R.string.localizable.onboardingButtonTitle3()),
      .init(image: R.image.onboarding_3()!,
            buttonTitle: R.string.localizable.onboardingButtonTitle4())
  ], contentIndex: 0)

  // MARK: Initializer
  init(coordinator: OnboardingCoordinator) {
    self.coordinator = coordinator
  }
}

// MARK: - Reactor
extension OnboardingReactor: Reactor {
  enum Action {
    case showNextContent
    case willEndDragging(index: Int)
  }

  enum Mutation {
    case didShowNextContent
    case calculateIndex(index: Int)
  }

  struct State {
    var contents: [Onboarding]
    var contentIndex: Int
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .showNextContent:
      return .just(.didShowNextContent)
    case .willEndDragging(let index):
      return .just(.calculateIndex(index: index))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .didShowNextContent:
      if state.contentIndex == state.contents.count - 1 {
        coordinator.showNextScene()
      } else {
        newState.contentIndex += 1
      }
    case .calculateIndex(let index):
      newState.contentIndex = index
    }

    return newState
  }
}
