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

    static let sidePadding: CGFloat = 40

    // MARK: - Properties

    private weak var labelContainerView: UIView!
    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!
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
        titleLabel.text = onboarding.title
        descriptionLabel.text = onboarding.description
        imageView.image = onboarding.image
    }
}

private extension OnboardingCollectionViewCell {
    func setupViews() {
        self.labelContainerView = UIView().then {
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }

        self.titleLabel = UILabel().then {
            $0.font = .t_B(28)
            $0.textColor = .black
            labelContainerView.addSubview($0)
        }

        self.descriptionLabel = UILabel().then {
            $0.font = .t_R(18)
            $0.textColor = .black
            $0.numberOfLines = 0
            labelContainerView.addSubview($0)
        }

        self.imageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
        }
    }

    func setupLayoutConstraints() {
        labelContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.width.equalTo(contentView.frame.width - (Self.sidePadding * 3))
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(labelContainerView.snp.bottom).offset(46)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}
