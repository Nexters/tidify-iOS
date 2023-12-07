//
//  FolderCreationViewModel.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/11/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain

final class FolderCreationViewModel: ViewModelType {
  typealias UseCase = FolderCreationUseCase

  enum Action {
    case didTapCreateFolderButton(_ requestDTO: FolderRequestDTO)
    case didTapUpdateFolderButton(id: Int, requestDTO: FolderRequestDTO)
  }

  struct State: Equatable {
    var errorType: FolderCreationError?
    var isSuccess: Bool
  }

  let useCase: UseCase
  @Published var state: State

  init(useCase: UseCase) {
    self.useCase = useCase
    state = .init(errorType: nil, isSuccess: false)
  }

  func action(_ action: Action) {
    switch action {
    case .didTapCreateFolderButton(let requestDTO):
      createFolder(requestDTO)
    case .didTapUpdateFolderButton(let id, let requestDTO):
      updateFolder(id: id, requestDTO: requestDTO)
    }
  }
}

private extension FolderCreationViewModel {
  func createFolder(_ requestDTO: FolderRequestDTO) {
    Task {
      do {
        try await useCase.createFolder(request: requestDTO)
        state.isSuccess = true
      } catch {
        state.errorType = .failCreateFolder
      }
    }
  }

  func updateFolder(id: Int, requestDTO: FolderRequestDTO) {
    Task {
      do {
        try await useCase.updateFolder(id: id, request: requestDTO)
        state.isSuccess = true
      } catch {
        state.errorType = .failUpdateFolder
      }
    }
  }
}
