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
  private var disposeBag: DisposeBag!
  private var bookmarkRepository: MockBookmarkRepository!
  private var folderRepository: MockFolderRepository!
  private var useCase: BookmarkCRUDUseCase!

  override func setUp() {
    super.setUp()

    self.disposeBag = .init()
    self.bookmarkRepository = MockBookmarkRepository()
    self.folderRepository = MockFolderRepository()
    self.useCase = DefaultBookmarkCRUDUseCase(bookmarkRepository: bookmarkRepository, folderRepository: folderRepository)
  }

  override func tearDown() {
    super.tearDown()

    self.disposeBag = nil
    self.bookmarkRepository = nil
    self.folderRepository = nil
    self.useCase = nil
  }

  func test_whenFetchBookmark_thenShouldNotEmpty() {
    let requestDTO: BookmarkListRequestDTO = .init(page: 0)
    useCase.fetchBookmarkList(requestDTO: requestDTO)
      .subscribe(onNext: { bookmarks, _, _ in
        XCTAssert(!bookmarks.isEmpty)
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenFetchBookmarkWithKeyword_thenResultShouldContainsKeyword() {
    let requestDTO: BookmarkListRequestDTO = .init(page: 0, keyword: "tistory")
    useCase.fetchBookmarkList(requestDTO: requestDTO)
      .subscribe(onNext: { bookmarks, _, _ in
        XCTAssert(bookmarks.allSatisfy({ $0.name.contains(requestDTO.keyword!) }))
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenCreateBookmark_thenBookmarkRepositoryContainsCreatedBookmark() {
    let newBookmarkRequestDTO: BookmarkRequestDTO = .init(folderID: 0, url: "duwjdtn11.tistory.com", name: "Tistory")

    useCase.createBookmark(requestDTO: newBookmarkRequestDTO)
      .flatMapLatest { _ -> Observable<FetchBookmarkListResposne> in self.useCase.fetchBookmarkList(requestDTO: .init(page: 0)) }
      .subscribe(onNext: { bookmarks, _, _ in
        XCTAssertTrue(bookmarks.contains(where: { $0.urlString == newBookmarkRequestDTO.url && $0.name == newBookmarkRequestDTO.name }))
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenTryDeleteNonMatchedBookmark_thenReturnError() {
    useCase.deleteBookmark(bookmarkID: -1)
      .subscribe(onNext: {
        XCTAssert(false)
      }, onError: { error in
        XCTAssert(BookmarkError.cannotFindMachedBookmark == error as! BookmarkError)
      })
      .disposed(by: disposeBag)
  }

  func test_whenDeleteBookmark_thenRepositoryShuldNotContainDeletedBookmark() {
    let requestDTO: BookmarkRequestDTO = .init(folderID: 0, url: "test.com", name: "DeleteTarget")
    useCase.createBookmark(requestDTO: requestDTO)
      .flatMapLatest { _ -> Observable<Void> in self.useCase.deleteBookmark(bookmarkID: 99) }
      .subscribe(onNext: {
        if self.bookmarkRepository.bookmarks.contains(where: { $0.urlString == requestDTO.url && $0.name == requestDTO.name }) {
          XCTAssert(false)
        } else {
          XCTAssert(true)
        }
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }

  func test_whenUpdateBookmark_thenShouldBeUpdated() {
    let bookmarkID: Int = 0
    let requestDTO: BookmarkRequestDTO = .init(folderID: 0, url: "www.duwjdtn11.tistory.com", name: "UpdatedBookmark")

    useCase.updateBookmark(id: bookmarkID, requestDTO: requestDTO)
      .flatMapLatest { _ -> Observable<FetchBookmarkListResposne> in self.useCase.fetchBookmarkList(requestDTO: .init(page: 0)) }
      .subscribe(onNext: { bookmarks, _, _ in
        if let bookmark = bookmarks.first(where: { $0.id == bookmarkID }) {
          XCTAssertEqual(requestDTO.url == bookmark.urlString, requestDTO.name == bookmark.name)
        } else {
          XCTAssert(false)
        }
      }, onError: { _ in
        XCTAssert(false)
      })
      .disposed(by: disposeBag)
  }
}
