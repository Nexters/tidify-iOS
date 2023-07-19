//
//  NetworkMonitor.swift
//  TidifyData
//
//  Created by 여정수 on 2023/07/19.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import Network

public final class NetworkMonitor {

  // MARK: Properties
  public static let shared: NetworkMonitor = .init()
  private let queue: DispatchQueue = .global()
  private let monitor: NWPathMonitor = .init()
  public private(set) var isConnected: Bool = false

  // MARK: Initializer
  private init() {}
}

// MARK: - Private
public extension NetworkMonitor {
  func startMonitoring() {
    monitor.start(queue: queue)

    monitor.pathUpdateHandler = { path in
      self.isConnected = path.status == .satisfied
    }
  }
}
