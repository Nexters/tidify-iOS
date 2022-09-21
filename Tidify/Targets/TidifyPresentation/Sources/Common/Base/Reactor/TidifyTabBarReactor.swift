//
//  TidifyTabBarReactor.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import ReactorKit

final class TidifyTabBarReactor {

  // MARK: Properties
  var initialState: State = .init(selectedTab: TabBarItem.home)
}

// MARK: - Reactor
extension TidifyTabBarReactor: Reactor {
  enum Action {
    case selectHomeTab
    case selectSearchTab
    case selectFolderTab
  }

  enum Mutation {
    case didShowSelectedTab(tabBarItem: TabBarItem)
  }

  struct State {
    var selectedTab: TabBarItem
  }

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .selectHomeTab:
      return .just(.didShowSelectedTab(tabBarItem: TabBarItem.home))
    case .selectSearchTab:
      return .just(.didShowSelectedTab(tabBarItem: TabBarItem.search))
    case .selectFolderTab:
      return .just(.didShowSelectedTab(tabBarItem: TabBarItem.folder))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState: State = state

    switch mutation {
    case .didShowSelectedTab(let tabBarItem):
      newState.selectedTab = tabBarItem
    }

    return newState
  }
}
