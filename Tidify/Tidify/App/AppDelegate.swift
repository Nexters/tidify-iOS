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
    var mainCoordinator: MainCoordinator?

    // MARK: - Methods

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
            RxKakaoSDKCommon.initSDK(appKey: kakaoApiKey)
        } else {
            Log.info("카카오 SDK가 초기화되지 않았습니다.")
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let mainCoordinator = MainCoordinator(window: window)
        self.mainCoordinator = mainCoordinator

        guard let accessToken = UserDefaults.standard.string(forKey: "access_token") else {
            mainCoordinator.startWithSignIn()
            return true
        }

        // accessToken 기반으로 authorization 받아오는 로직이 필요함.
//        ApiProvider.request(AuthAPI.auth(socialLoginType: .kakao, accessToken: accessToken))


        mainCoordinator.start()
        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
}