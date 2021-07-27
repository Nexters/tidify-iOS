//
//  BaseViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Foundation
import RxCocoa
import RxSwift
import SnapKit
import UIKit

class BaseViewController: UIViewController {

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()
    }

    // MARK: - Methods

    func setupViews() {
        // Override Layout
    }

    func setupLayoutConstraints() {
        // Override Constraints
    }
}
