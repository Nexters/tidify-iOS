//
//  SearchReactorTests.swift
//  TidifyPresentationTests
//
//  Created by 여정수 on 2023/06/01.
//  Copyright © 2023 Tidify. All rights reserved.
//

import XCTest

import Nimble
import RxSwift
import RxTest
import RxNimble

@testable import TidifyDomain
@testable import TidifyPresentation
final class SearchReactorTests: XCTestCase {

  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var searchRepository: MockSearchRepository!
  private var coordinator: MockSearchCoordinator!
  private var useCase: SearchUseCase!
  private var reactor: SearchReactor!

  override func setUp() {
    super.setUp()

    scheduler = .init(initialClock: 0)
    disposeBag = .init()
    searchRepository = MockSearchRepository()
    coordinator = MockSearchCoordinator()
    useCase = DefaultSearchUseCase(searchRepository: searchRepository)
    reactor = .init(coordinator: coordinator, useCase: useCase)
  }

  override func tearDown() {
    super.tearDown()

    scheduler = nil
    disposeBag = nil
    searchRepository = nil
    coordinator = nil
    useCase = nil
    reactor = nil
  }

  func test_whenViewWillAppear_thenStateSearchHistoryShouldNotEmpty() {
    scheduler
      .createColdObservable([
        .next(1, SearchReactor.Action.viewWillAppear)
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.searchHistory.isEmpty })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, true),
        .next(1, false)
      ]))
  }

  func test_whenUserSearchQuery_thenSearchAllResultShouldContainQuery() {
    scheduler
      .createColdObservable([
        .next(0, SearchReactor.Action.searchQuery("Test")),
        .next(1, SearchReactor.Action.searchQuery("Github"))
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.searchResult.allSatisfy { $0.name.contains("Github") } })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, true),
        .next(1, true)
      ]))
  }

  func test_whenUserInputKeyword_thenSearchResultShouldEmpty() {
    scheduler
      .createColdObservable([
        .next(0, SearchReactor.Action.searchQuery("Github")),
        .next(1, SearchReactor.Action.inputKeyword)
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.searchResult.isEmpty })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, false),
        .next(1, true)
      ]))
  }
}
