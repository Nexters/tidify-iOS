//
//  OnboardingCollectionViewCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import SnapKit
import Then

final class OnboardingCollectionViewCell: UICollectionViewCell {

  // MARK: - Constants
  static let identifer: String = "\(OnboardingCollectionViewCell.self)"

  // MARK: - Properties
  private weak var imageView: UIImageView!
  private let textView: UITextView = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    imageView.image = nil
  }

  func configure(_ onboarding: Onboarding) {
    imageView.image = onboarding.image

    textView.delegate = self
  }
}

private extension OnboardingCollectionViewCell {
  func setupViews() {
    self.imageView = UIImageView().then {
      $0.contentMode = .scaleAspectFill
      contentView.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}

extension OnboardingCollectionViewCell: UITextViewDelegate {

}
