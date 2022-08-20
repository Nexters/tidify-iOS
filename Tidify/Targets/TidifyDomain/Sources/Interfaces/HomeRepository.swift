//
//  HomeRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol HomeRepository {
  func fetchBookmark() -> Single<BookmarkListDTO>
}
