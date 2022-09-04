//
//  NetworkPlugin.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import RxMoya
import Moya

public struct NetworkPlugin: PluginType {
  public func willSend(_ request: RequestType, target: TargetType) {
    #if DEBUG
    guard let request = request.request,
          let method = request.method else { return }

    let methodRawValue = method.rawValue
    let requestDescription = request.debugDescription
    let headers = String(describing: target.headers)

    let message = """
    [Moya-Logger] - @\(methodRawValue): \(requestDescription)
    [Moya-Logger] headers: \(headers)
    \n
    """
    Beaver.debug(message)
    #endif
  }

  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    #if DEBUG
    Beaver.debug("[Moya-Logger] - \(target.baseURL)\(target.path)")

    switch result {
    case .success(let response):
      guard let json = try? response.mapJSON() as? [String: Any] else { return }
      Beaver.debug("[Moya-Logger] Success: \(json)")
    case .failure(let error):
      Beaver.warning("[Moya-Logger] Fail: \(String(describing: error.errorDescription))")
    }
    #endif
  }
}
