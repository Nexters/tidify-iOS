import TidifyPresentation
import UIKit

import KakaoSDKCommon
import SwiftyBeaver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private var mainCoordinator: MainCoordinator?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window

    setupLibrary()

    self.mainCoordinator = DefaultMainCoordinator(window: window)

    mainCoordinator?.start()

    return true
  }
}

private extension AppDelegate {
  func setupLibrary() {
    // Setup SwiftyBeaver
    SwiftyBeaver.addDestination(ConsoleDestination())

    // KakaoSDK
    guard let appKey: String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String
    else { return }
    KakaoSDK.initSDK(appKey: appKey)
  }
}
