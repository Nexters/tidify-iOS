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

  private let coordinator: BookmarkCreationCoordinator
  private let useCase: BookmarkUseCase

  // MARK: - Constructor
  init(coordinator: BookmarkCreationCoordinator, useCase: BookmarkUseCase) {
    self.coordinator = coordinator
    self.useCase = useCase
  }

  enum Action {
    case didTapCreateButton(_ requestDTO: BookmarkRequestDTO)
  }

  enum Mutation {
    case requestCreateBookmark(_ bookmark: Bookmark)
  }

  struct State {
    var didRequestCreateBookmark: Void = ()
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .didTapCreateButton(let requestDTO):
      return useCase.createBookmark(requestDTO: requestDTO)
        .map { .requestCreateBookmark($0) }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .requestCreateBookmark:
      newState.didRequestCreateBookmark = ()
    }

    return newState
  }
}
