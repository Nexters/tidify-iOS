//
//  DIContainer.swift
//  Tidify
//
//  Created by Ian on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

public typealias DependencyFactoryClosure = (DIContainer) -> Any

public protocol Assemblable {
  func assemble(container: DIContainer)
}

private protocol DIContainable {
  func register<Service>(type: Service.Type, factoryClosure: @escaping DependencyFactoryClosure)
  func resolve<Service>(type: Service.Type) -> Service?
}

public final class DIContainer: DIContainable {

  // MARK: - Properties
  public static let shared: DIContainer = .init()
  var services: [String: DependencyFactoryClosure] = [:]

  // MARK: - Initializer
  private init() {}

  // MARK: - Methods
  public func register<Service>(type: Service.Type, factoryClosure: @escaping DependencyFactoryClosure) {
    services["\(type)"] = factoryClosure
  }

  public func resolve<Service>(type: Service.Type) -> Service? {
    let service = services["\(type)"]?(self) as? Service

    if service == nil {
      Beaver.error("\(type) resolve Error")
      print(services)
    }

    return service
  }
}
