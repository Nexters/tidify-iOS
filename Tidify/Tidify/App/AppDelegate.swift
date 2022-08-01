//
//  AppDelegate.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKCommon
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - Properties

  var window: UIWindow?
  private var mainCoordinator: MainCoordinator?
  private let accessToken = UserDefaultManager.accessToken

  // MARK: - Methods

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      if let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
        RxKakaoSDK.initSDK(appKey: kakaoApiKey)
      } else {
        Log.info("카카오 SDK가 초기화되지 않았습니다.")
      }

      let window = UIWindow(frame: UIScreen.main.bounds)
      let mainCoordinator = DefaultMainCoordinator(window: window)
      self.mainCoordinator = mainCoordinator

      if !UserDefaultManager.didOnboarded {
        mainCoordinator.startWithOnboarding()
        return true
      }

      if accessToken != "" {
        Environment.shared.authorization = accessToken
      } else {
        mainCoordinator.startWithSignIn()
        return true
      }

      mainCoordinator.start()
      return true
    }

  open func application(
    _ app: UIApplication, open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.rx.handleOpenUrl(url: url)
    }

    return false
  }
}
