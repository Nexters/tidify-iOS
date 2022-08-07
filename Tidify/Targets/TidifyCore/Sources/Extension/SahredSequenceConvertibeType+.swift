//
//  SahredSequenceConvertibeType+.swift
//  TidifyCore
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxCocoa
import RxSwift

// MARK: - SahredSequenceConvertibeType Extension
public extension SharedSequenceConvertibleType {
  func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
    map { _ in }
  }
}
