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
  private var bookmarkRepository: MockBookmarkRepository!
  private var folderRepository: FolderRepository!
  private var useCase: BookmarkCRUDUseCase!
  private var reactor: HomeReactor!

  override func setUpWithError() throws {
    try super.setUpWithError()

    scheduler = .init(initialClock: 0)
    disposeBag = .init()
    coordinator = MockHomeCoordinator()
    bookmarkRepository = MockBookmarkRepository()
    folderRepository = MockFolderRepository()
    useCase = DefaultBookmarkCRUDUseCase(bookmarkRepository: bookmarkRepository, folderRepository: folderRepository)
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

  func test_whenViewWillAppear_thenStateBookmarkShouldNotEmpty() {
    scheduler
      .createColdObservable([
        .next(1, HomeReactor.Action.fetchBookmarks(isInitialRequest: true))
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.bookmarks.isEmpty })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, true),
        .next(1, false)
      ]))
  }

  func test_whenDidSelectCell_thenPushWebViewShouldTrue() {
    let bookmark = bookmarkRepository.bookmarks[0]

    scheduler
      .createColdObservable([
        .next(1, HomeReactor.Action.didSelect(bookmark))
      ])
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.didPushWebView })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, false),
        .next(1, true)
      ]))
  }

  func test_whenDeleteBookmark_thenStateBookmarksShouldNotContainDeletedBookmark() {
    let bookmark = bookmarkRepository.bookmarks[0]

    scheduler
      .createColdObservable([
        .next(0, HomeReactor.Action.fetchBookmarks(isInitialRequest: true)),
        .next(3, HomeReactor.Action.didDelete(bookmark))
    ])
    .bind(to: reactor.action)
    .disposed(by: disposeBag)

    expect(self.reactor.state.map { $0.bookmarks.contains { $0.id == bookmark.id } })
      .events(scheduler: scheduler, disposeBag: disposeBag)
      .to(equal([
        .next(0, true),
        .next(3, false)
      ]))
  }
}
