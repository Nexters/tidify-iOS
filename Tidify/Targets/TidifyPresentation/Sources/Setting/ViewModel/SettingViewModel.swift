//
//  SettingViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class SettingViewModel: ViewModelType {
  typealias UseCase = UserUseCase

  enum Action: Equatable {
    case didTapSignOutButton
  }

  struct State: Equatable {
    var isSuccess: Bool
    var error: UserError?
  }

  let useCase: UseCase
  @Published var state: State

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(isSuccess: false, error: nil)
  }

  func action(_ action: Action) {
    state.error = nil
    
    switch action {
    case .didTapSignOutButton:
      signOut()
    }
  }
}

private extension SettingViewModel {
  func signOut() {
    Task {
      do {
        try await useCase.signOut()
        state.isSuccess = true
      } catch {
        state.error = .failSignOut
      }
    }
  }
}
