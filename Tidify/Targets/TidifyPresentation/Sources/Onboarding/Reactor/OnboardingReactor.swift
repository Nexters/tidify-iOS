//
//  OnboardingReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class OnboardingReactor {

  // MARK: Properties
  private let coordinator: OnboardingCoordinator
  var initialState: State = .init(
    contents: [
      .init(image: .init(named: "onboardingImage_0")!, buttonTitle: "공유버튼 누르면 바로 북마크 저장"),
      .init(image: .init(named: "onboardingImage_1")!, buttonTitle: "링크주소만 넣어주세요"),
      .init(image: .init(named: "onboardingImage_2")!, buttonTitle: "누구보다 빠르게 기억할게요"),
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
