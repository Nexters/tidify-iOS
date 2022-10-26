//
//  SettingReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Foundation

import ReactorKit

final class SettingReactor: Reactor {

  enum Sections: Int, CaseIterable {
    case accountManaging
    case dataManaging

    var numberOfRows: Int {
      rowTitles.count
    }

    var sectionTitle: String {
      switch self {
      case .accountManaging:
        return "계정관리"
      case .dataManaging:
        return "데이터 관리"
      }
    }

    var rowTitles: [String] {
      switch self {
      case .accountManaging:
        return ["소셜 로그인"]
      case .dataManaging:
        return ["이미지 캐시 정리", "모든 캐시 정리", "로그아웃", "앱 버전"]
      }
    }
  }

  // MARK: - Properties
  var initialState: State = .init()

  private let coordinaotr: SettingCoordinator

  // MARK: - Initializer
  init(coordinator: SettingCoordinator) {
    self.coordinaotr = coordinator
  }

  enum Action {
    case didTapCell(indexPath: IndexPath)
  }

  enum Mutation {
    case setAlertType(alertType: AlertPresenter.AlertType?)
    case pushSocialLoginScene
  }

  struct State {
    var presentAlert: AlertPresenter.AlertType? = nil
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCell(let indexPath):
      if indexPath.section == Sections.dataManaging.rawValue {
        switch indexPath.row {
        case 0: return .just(.setAlertType(alertType: .removeImageCache))
        case 1: return .just(.setAlertType(alertType: .removeAllCache))
        case 2: return .just(.setAlertType(alertType: .logout))

        default:
          return .just(.setAlertType(alertType: nil))
        }
      } else {
        return .just(.pushSocialLoginScene)
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .pushSocialLoginScene:
      coordinaotr.pushSocialLoginSettingScene()
    case .setAlertType(let alertType):
      newState.presentAlert = alertType
    }

    return newState
  }
}
