//
//  Publisher+.swift
//  TidifyPresentation
//
//  Created by 여정수 on 12/30/23.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
  public func receiveOnMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
    self.receive(on: DispatchQueue.main)
  }

  public func withUnretained<T: AnyObject>(_ object: T) -> Publishers.CompactMap<Self, (T, Self.Output)> {
    compactMap { [weak object] output in
      guard let object else {
        return nil
      }

      return (object, output)
    }
  }
}
