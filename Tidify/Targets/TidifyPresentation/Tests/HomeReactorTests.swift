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

@testable import TidifyPresentation

final class HomeReactorTests: XCTestCase {

  // MARK: - Properties
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var coordinator: MockHomeCoordinator!
  private var useCase: MockHomeUseCase!
  private var reactor: HomeReactor!

  override func setUp() {
    super.setUp()

    scheduler = .init(initialClock: 0)
    disposeBag = .init()
    coordinator = .init()
    useCase = .init()
    reactor = .init(coordinator: coordinator, useCase: useCase)
  }

  override func tearDown() {
    super.tearDown()

    scheduler = nil
    disposeBag = nil
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
}
