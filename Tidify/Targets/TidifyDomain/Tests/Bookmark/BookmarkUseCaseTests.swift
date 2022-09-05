//
//  BookmarkUseCaseTests.swift
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

final class BookmarkUseCaseTests: XCTestCase {

  // MARK: - Properteis
  private var scheduler: TestScheduler!
  private var disposeBag: DisposeBag!
  private var repository: BookmarkRepository!
  private var useCase: BookmarkUseCase!

  override func setUp() {
    super.setUp()

    self.scheduler = .init(initialClock: 0)
    self.disposeBag = .init()
    self.repository = MockBookmarkRepository()
    self.useCase = DefaultBookmarkUseCase(repository: repository)
  }

  override func tearDown() {
    super.tearDown()

    self.scheduler = nil
    self.disposeBag = nil
    self.repository = nil
    self.useCase = nil
  }

  func test_whenFetchBookmark_thenIsNotEmpty() {
    useCase.fetchBookmarks(id: 0)
      .subscribe(onNext: { bookmarks in
        XCTAssert(!bookmarks.isEmpty)
      }, onError: { error in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenCreateBookmark_thenReturnCreatedObject() {
    useCase.createBookmark(
      url: "www.google.com",
      title: "Google",
      folder: "NONE"
    )
    .subscribe(onNext: { bookmark in
      XCTAssert(true)
    }, onError: { error in
      XCTAssert(false)
    })
    .disposed(by: disposeBag)
  }
}
