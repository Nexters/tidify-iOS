//
//  SearchUseCaseTests.swift
//  TidifyDomainTests
//
//  Created by Ian on 2022/10/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import XCTest

import RxSwift
@testable import TidifyDomain

final class SearchUseCaseTests: XCTestCase {

  // MARK: - Properties
  private var disposeBag: DisposeBag!
  private var repository: SearchRepository!
  private var useCase: SearchUseCase!

  override func setUp() {
    super.setUp()

    self.disposeBag = .init()
    self.repository = MockSearchRepository()
    self.useCase = DefaultSearchUseCase(searchRepository: repository)
  }

  override func tearDown() {
    super.tearDown()

    self.disposeBag = nil
    self.repository = nil
    self.useCase = nil
  }

  func test_whenEraseAllHistory_thenWillSuccess() {
    useCase.eraseAllSearchHistory()
      .subscribe(onNext: { _ in
        XCTAssert(true)
      }, onError: { error in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenFetchAllHistory_thenWillNotEmpty() {
    useCase.fetchSearchHistory()
      .subscribe(onNext: { searchHistory in
        if !searchHistory.isEmpty {
          XCTAssert(true)
        } else {
          XCTAssert(false)
        }
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenFetchSearchResult_thenWillReturnBookamrk() {
    useCase.fetchSearchResult(query: "Stub Data")
      .subscribe(onNext: { bookmarks in
        if !bookmarks.isEmpty {
          XCTAssert(true)
        } else {
          XCTAssert(false)
        }
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }
}
