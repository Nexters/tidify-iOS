import TidifyPresentation
import UIKit


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  private var mainCoordinator: MainCoordinator?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.window = window
    mainCoordinator = DefaultMainCoordiator(window: window)

    mainCoordinator?.start()

    return true
  }

}
