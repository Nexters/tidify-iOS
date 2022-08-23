import TidifyCore
import TidifyData
import TidifyDomain
import TidifyPresentation
import UIKit

import KakaoSDKCommon
import SwiftyBeaver

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

    let navigationController: UINavigationController = .init(nibName: nil, bundle: nil)
    self.navigationController = navigationController
    window.rootViewController = navigationController

    setupLibrary()
    assemble()

    self.mainCoordinator = DefaultMainCoordinator(navigationController: navigationController)

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

  func assemble() {
    guard let navigationController = navigationController else { return }
    let container: DIContainer = .shared
    DataAssembly().assemble(container: container)
    DomainAssembly().assemble(container: container)
    PresentationAssembly(navigationController: navigationController).assemble(container: container)
  }
}
