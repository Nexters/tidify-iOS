//
//  BookmarkCreationReactor.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import ReactorKit

final class BookmarkCreationReactor: Reactor {

  // MARK: - Properties
  var initialState: State = .init()

  private weak var coordinator: BookmarkCreationCoordinator?
  private let useCase: BookmarkCreationUseCase

  // MARK: - Constructor
  init(
    coordinator: BookmarkCreationCoordinator,
    useCase: BookmarkCreationUseCase
  ) {
    self.coordinator = coordinator
    self.useCase = useCase
  }

  enum Action {
    case viewWillAppear
    case didTapCreateButton(_ requestDTO: BookmarkRequestDTO)
  }

  enum Mutation {
    case requestCreateBookmark
    case setFolders(folders: [Folder])
  }

  struct State {
    var folders: [Folder] = []
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .viewWillAppear:
      return useCase.fetchFolders()
        .map { .setFolders(folders: $0) }

    case .didTapCreateButton(let requestDTO):
      return useCase.createBookmark(requestDTO: requestDTO)
        .map { .requestCreateBookmark }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .requestCreateBookmark:
      coordinator?.close()

    case .setFolders(let folders):
      newState.folders = folders
    }

    return newState
  }
}
