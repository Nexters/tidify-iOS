//
//  HomeReactorTests.swift
//  TidifyPresentationTests
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import XCTest

import Nimble
import RxNimble
import RxSwift
import RxTest

@testable import TidifyDomain
@testable import TidifyPresentation

final class HomeReactorTests: XCTestCase {

  // MARK: - Properties
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var coordinator: MockHomeCoordinator!
  private var repository: HomeRepository!
  private var useCase: HomeUseCase!
  private var reactor: HomeReactor!

  override func setUpWithError() throws {
    try super.setUpWithError()

    scheduler = .init(initialClock: 0)
    disposeBag = .init()
    coordinator = MockHomeCoordinator()
    repository = MockHomeRepository()
    useCase = DefaultHomeUseCase(repository: repository)
    reactor = .init(coordinator: coordinator, useCase: useCase)
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()

    scheduler = nil
    disposeBag = nil
    coordinator = nil
    useCase = nil
    reactor = nil
  }

  func test_whenViewWillAppear_thenStateBookmarkIsNotEmpty() {
    scheduler
      .createHotObservable([
        .next(5, HomeReactor.Action.viewWillAppear(id: 0)),
        .next(10, HomeReactor.Action.viewWillAppear(id: 0))
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.bookmarks.isEmpty })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, true),
        .next(5, false),
        .next(10, false)
      ]))
  }

  func test_whenDidSelectCell_thenPushWebViewIsTrue() {
    scheduler
      .createHotObservable([
        .next(5, HomeReactor.Action.didSelect(.stub()))
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.didPushWebView })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, false),
        .next(5, true)
      ]))
  }
}
