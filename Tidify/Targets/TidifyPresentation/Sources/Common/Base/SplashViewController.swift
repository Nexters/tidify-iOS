//
//  SplashViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/04/27.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

import Lottie
import SnapKit

final class SplashViewController: UIViewController {
  private let animationView: LottieAnimationView = .init(name: "splashLottie")
  private weak var coordinator: MainCoordinator?

  // MARK: Initializer
  init(coordinator: MainCoordinator) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()

    setupAnimationView()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    cooridnateAfterAnimation()
  }
}

// MARK: - Private
private extension SplashViewController {
  func setupAnimationView() {
    view.backgroundColor = .white

    animationView.do {
      $0.contentMode = .scaleAspectFit
      $0.loopMode = .repeat(1)
      $0.isHidden = true
      view.addSubview($0)
    }

    animationView.snp.makeConstraints {
      $0.width.equalTo(view.frame.width * 0.533)
      $0.height.equalTo(animationView.snp.width).multipliedBy(0.5)

      $0.center.equalToSuperview()
    }
  }
  
  func cooridnateAfterAnimation() {
    animationView.isHidden = false

    animationView.play { [weak self] _ in
      self?.coordinator?.start()
    }
  }
}
