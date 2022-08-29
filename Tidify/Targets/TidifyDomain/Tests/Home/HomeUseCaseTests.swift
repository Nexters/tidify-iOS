//
//  HomeUseCaseTests.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/08/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import XCTest

import Nimble
import RxNimble
import RxSwift
import RxTest
@testable import TidifyDomain

final class HomeUseCaseTests: XCTestCase {

  // MARK: - Properteis
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var homeRepository: HomeRepository!
  private var homeUseCase: HomeUseCase!

  override func setUp() {
    super.setUp()

    self.scheduler = .init(initialClock: 0)
    self.disposeBag = .init()
    self.homeRepository = MockHomeRepository()
    self.homeUseCase = DefaultHomeUseCase(repository: homeRepository)
  }

  override func tearDown() {
    super.tearDown()

    self.scheduler = nil
    self.disposeBag = nil
    self.homeRepository = nil
    self.homeUseCase = nil
  }

  func test_whenFetchBookmark_thenIsNotEmpty() {
    homeUseCase.fetchBookmark(id: 0)
      .subscribe(onNext: { bookmarks in
        XCTAssert(!bookmarks.isEmpty)
      }, onError: { error in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenCreateBookmark_thenReturnCreatedObject() {
    homeUseCase.createBookmark(
      url: "www.google.com",
      title: "Create",
      ogImageURL: nil,
      tags: "Test tags"
    )
    .subscribe(onNext: { bookmark in
      XCTAssert(true)
    }, onError: { error in
      XCTAssert(false)
    })
    .disposed(by: disposeBag)
  }
}
