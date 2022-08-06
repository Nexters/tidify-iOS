//
//  ObservableType+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

// MARK: ObservableType Extension
public extension ObservableType {
  func mapToVoid() -> Observable<Void> {
    return map { _ in }
  }
}
