//
//  HomeUseCase.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol HomeUseCase {
  var repository: HomeRepository { get set }

  func fetchBookmark() -> Observable<BookmarkListDTO>

}

public final class DefaultHomeUseCase: HomeUseCase {

  // MARK: - Properties
  public var repository: HomeRepository

  // MARK: - Initialize
  public init(repository: HomeRepository) {
    self.repository = repository
  }

  // MARK: - Methods
  public func fetchBookmark() -> Observable<BookmarkListDTO> {
    repository.fetchBookmark()
      .asObservable()
  }
}
