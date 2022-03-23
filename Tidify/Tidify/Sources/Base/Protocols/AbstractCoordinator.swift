//
//  AbstractCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

/// 모든 코디네이터가 공통적으로 따르는 프로토콜
protocol Coordinator: AnyObject {

  // MARK: - Properties

  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }

  // MARK: - Methods

  func start()
}
