//
//  Repositoriable.swift
//  TidifyCore
//
//  Created by 한상진 on 2022/11/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import TidifyPresentation
import UIKit

import Moya
import RxSwift

enum RequestError: Error {
  case error
}

public extension MoyaProvider {
  func request(_ target: Target) -> Single<Response> {
    Single<Response>.create { [weak self] single in
      let cancellableToken = self?.request(target, callbackQueue: nil, progress: nil) { result in
        switch result {
        case let .success(response):
          guard let responseData = try? response.map(DefaultResponse.self) else { return }
          guard responseData.apiResponse.isSuccess == false else {
            single(.success(response));
            break
          }
          
          self?.updateToken {
            single(.failure(RequestError.error))
          }
        case let .failure(error):
          single(.failure(error))
        }
      }
      
      return Disposables.create {
        cancellableToken?.cancel()
      }
    }
    .retry(2)
  }
  
  private func updateToken(completion: @escaping () -> Void) {
    let updateService: MoyaProvider<AuthService> = .init(plugins: [NetworkPlugin()])
    
    updateService.request(.updateToken) { result in
      switch result {
      case .success(let response):
        guard let responseData = try? response.map(UserTokenDTO.self) else { return }
        
        if responseData.response.code == "N200" {
          guard let accessTokenData = responseData.accessToken.data(using: .utf8) else { return }
          KeyChain.save(key: .accessToken, data: accessTokenData)
          completion()
        } else {
          KeyChain.deleteAll()
          guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let firstWindow = firstScene.windows.first
          else { return }
          
          let navigationController: UINavigationController = .init(nibName: nil, bundle: nil)
          PresentationAssembly(navigationController: navigationController)
            .assemble(container: DIContainer.shared)
          firstWindow.rootViewController = navigationController
          
          let mainCoordinator: DefaultMainCoordinator = .init(
            navigationController: navigationController
          )
          mainCoordinator.start()
        }
      case let .failure(error):
        print("❌ \(#file) - \(#line): \(#function) - Fail: \(error.localizedDescription)")
      }
    }
  }
}
