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

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
            RxKakaoSDKCommon.initSDK(appKey: kakaoApiKey)
        } else {
            Log.info("카카오 SDK가 초기화되지 않았습니다.")
        }

        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        mainCoordinator = MainCoordinator(navigationController: navigationController)

        guard UserDefaults.standard.string(forKey: "access_token") != nil else {
            mainCoordinator?.presentSignIn()
            return true
        }

        mainCoordinator?.start()
        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
}
