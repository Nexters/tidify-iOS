//
//  MainViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import Then

class MainViewController: UIViewController {
    weak var coordinator: MainCoordinator?

    private weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
