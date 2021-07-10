//
//  AppDelegate.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import KakaoSDKAuth
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let newBookMarkNotificationChannelName = "com.duwjdtn.Tidify.newBookMark" as CFString

    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        if let kakaoApiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String {
            RxKakaoSDKCommon.initSDK(appKey: kakaoApiKey)
        } else {
            Log.info("카카오 SDK가 초기화되지 않았습니다.")
        }

        let navigationController = UINavigationController()
        mainCoordinator = MainCoordinator(navigationController: navigationController)
//        mainCoordinator?.presentSignIn()
        mainCoordinator?.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

//        let notificationName = newBookMarkNotificationChannelName
//        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
//
//        CFNotificationCenterAddObserver(notificationCenter, nil, { (_: CFNotificationCenter?, _: UnsafeMutableRawPointer?, _: CFNotificationName?, object: UnsafeRawPointer?, _: CFDictionary?) in
//
//            print("received!")
//
//            if object != nil {
//                let decoded = UnsafePointer<UInt8>(object!.assumingMemoryBound(to: UInt8.self))
//                let newBookMark = String(cString: decoded)
//
//                Log.info(newBookMark)
//            }
//        }, notificationName, nil, CFNotificationSuspensionBehavior.deliverImmediately)

        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {

        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
}
