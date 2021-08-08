//
//  AbstractCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

/// Coordinator 추상화
protocol Coordinator: AnyObject {

    // MARK: - Properties

    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    // MARK: - Methods

    func start()
}

protocol TabChildCoordinator: Coordinator {
    func startPush()
    func show()
    func hide()
}
