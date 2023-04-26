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
        return ["로그아웃", "회원탈퇴"]
      case .dataManaging:
        return ["이미지 캐시 정리", "모든 캐시 정리", "앱 버전"]
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
  }

  struct State {
    var presentAlert: AlertPresenter.AlertType? = nil
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCell(let indexPath):
      switch indexPath.section {
      case 0:
        return .just(.setAlertType(alertType: indexPath.row == 0 ? .logout : .signOut))
      case 1:
        return .just(.setAlertType(alertType: indexPath.row == 0 ? .removeImageCache : .removeAllCache))

      default: return .empty()
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .setAlertType(let alertType):
      newState.presentAlert = alertType
    }

    return newState
  }
}
