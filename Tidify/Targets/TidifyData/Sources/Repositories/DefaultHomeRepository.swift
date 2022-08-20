//
//  DefaultHomeRepository.swift
//  Tidify
//
//  Created by Ian on 2022/08/20.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import RxSwift

public struct DefaultHomeRepository: HomeRepository {
  public func fetchBookmark() -> Single<BookmarkListDTO> {

  }
}
