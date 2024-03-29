import TidifyCore
import TidifyData
import TidifyDomain
import TidifyPresentation
import UIKit

import KakaoSDKAuth
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private var mainCoordinator: MainCoordinator?
  private var navigationController: UINavigationController?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    self.window = window

    NetworkMonitor.shared.startMonitoring()

    let navigationController: UINavigationController = .init(nibName: nil, bundle: nil)
    self.navigationController = navigationController
    window.rootViewController = navigationController

    setupNavigationBar()
    setupLibrary()
    assemble()

    self.mainCoordinator = DefaultMainCoordinator(navigationController: navigationController)
    mainCoordinator?.startSplash()

    return true
  }

  func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.handleOpenUrl(url: url, options: options)
    }
    return false
  }
}

private extension AppDelegate {
  func setupNavigationBar() {
    UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    let navigationBar: UINavigationBar = UINavigationBar.appearance()
    navigationBar.titleTextAttributes = [
      .foregroundColor: UIColor.t_gray(weight: 800),
      .font: UIFont.t_B(17)
    ]
    navigationBar.backIndicatorImage = UIImage(named: "backButtonIcon")
    navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backButtonIcon")
  }

  func setupLibrary() {

    // KakaoSDK
    guard let appKey: String = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String
    else { return }
    KakaoSDK.initSDK(appKey: appKey)
  }

  func assemble() {
    guard let navigationController = navigationController else { return }
    let container: DIContainer = .shared
    DataAssembly().assemble(container: container)
    DomainAssembly().assemble(container: container)
    PresentationAssembly(navigationController: navigationController).assemble(container: container)
  }
}
