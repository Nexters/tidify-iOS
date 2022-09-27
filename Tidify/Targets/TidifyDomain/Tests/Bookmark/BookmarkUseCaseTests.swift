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
    useCase.fetchBookmarkList()
      .subscribe(onNext: { bookmarks in
        XCTAssert(!bookmarks.isEmpty)
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenCreateBookmark_thenReturnCreatedObject() {
    useCase.createBookmark(
      requestDTO: .init(
        url: "www.google.com",
        title: "Google"
      )
    )
    .subscribe(onNext: { bookmark in
      if bookmark.title == "Google" {
        XCTAssert(true)
      } else {
        XCTAssert(false)
      }
    }, onError: { _ in
      XCTAssert(false)
    })
    .disposed(by: disposeBag)
  }

  func test_whenDeleteBookmark_thenReturnVoid() {
    useCase.deleteBookmark(bookmarkID: 0)
      .subscribe(onNext: {
        XCTAssert(true)
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenUpdateBookmark_thenReturnVoid() {
    useCase.updateBookmark(
      bookmarkID: 0,
      requestDTO: .init(
        url: "www.google.com", title: "Google"
      )
    )
    .subscribe(onNext: {
      XCTAssert(true)
    }, onError: { _ in
      XCTAssert(false)
    })
    .disposed(by: disposeBag)
  }
}
