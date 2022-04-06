//
//  OnboardingCollectionViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import SnapKit
import Then
import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {

  // MARK: - Constants

  // MARK: - Properties
  private weak var imageView: UIImageView!

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

  func setOnboarding(_ onboarding: Onboarding) {
    imageView.image = onboarding.image
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
