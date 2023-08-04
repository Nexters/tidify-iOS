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

  func test_whenFetchSearchHistory_thenShouldNotEmpty() {
    useCase.fetchSearchHistory()
      .subscribe(onNext: { history in
        if history.isEmpty {
          XCTAssert(false)
        } else {
          XCTAssert(true)
        }
      })
      .disposed(by: disposeBag)
  }

  func test_whenEraseAllHistory_thenShouldBeEmpty() {
    useCase.eraseAllSearchHistory()
      .flatMapLatest { _ -> Observable<[String]> in self.useCase.fetchSearchHistory() }
      .subscribe(onNext: { history in
        XCTAssert(history.isEmpty)
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenSearchWithKeyword_thenShouldReturnMappedBookmarks() {
    let requestDTO: BookmarkListRequest = .init(page: 0, keyword: "Github")
    useCase.fetchSearchResult(requestDTO: requestDTO)
      .subscribe(onNext: { response in
        XCTAssert(response.bookmarks.allSatisfy({ bookmark in bookmark.name.contains("Github") }))
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenSearchWithEmptyKeyword_thenShouldReturnError() {
    let requestDTO: BookmarkListRequest = .init(page: 0, keyword: "")

    useCase.fetchSearchResult(requestDTO: requestDTO)
      .subscribe(onNext: { _ in
        XCTAssert(false)
      }, onError: { error in
        XCTAssert(SearchError.emptySearchQuery == error as! SearchError)
      })
      .disposed(by: disposeBag)
  }
}
