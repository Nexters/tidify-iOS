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
    
    updateService.request(.updateToken) { [weak self] result in
      switch result {
      case .success(let response):
        guard self?.isSuccessRefreshAccessToken(response, completion) == false else { return }
        
        KeyChain.deleteAll()
        self?.presentExpiredSessionAlert()
      case let .failure(error):
        print("❌ \(#file) - \(#line): \(#function) - Fail: \(error.localizedDescription)")
      }
    }
  }
  
  private func isSuccessRefreshAccessToken(
    _ response: Response,
    _ completion: @escaping () -> Void
  ) -> Bool {
    if let responseData = try? response.map(UserTokenDTO.self),
       responseData.response.isSuccess,
       let accessTokenData = responseData.accessToken.data(using: .utf8) {
      KeyChain.save(key: .accessToken, data: accessTokenData)
      completion()
      return true
    }
    return false
  }
  
  private func presentExpiredSessionAlert() {
    guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let firstWindow = firstScene.windows.first,
          let rootViewController = firstWindow.rootViewController as? UINavigationController
    else { return }
    
    let alertController: UIAlertController = .init(
      title: "세션이 만료되었습니다",
      message: "다시 로그인 후 시도해 주세요",
      preferredStyle: .alert
    )
    
    let action: UIAlertAction = .init(
      title: "확인",
      style: .default,
      handler: { _ in
        let mainCoordinator: DefaultMainCoordinator = .init(
          navigationController: .init(nibName: nil, bundle: nil)
        )
        mainCoordinator.start()
      }
    )
    alertController.addAction(action)
    
    rootViewController.topViewController?.present(
      alertController,
      animated: true
    )
  }
}
