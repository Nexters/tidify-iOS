//
//  BottomSheetLabelColorTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BottomSheetLabelColorTableViewCell: UITableViewCell {

  // MARK: - Constants

  static let circleColorWidth: CGFloat = 30
  static let superViewToImageViewHorizontalSpacing: CGFloat = 20
  static let imageViewToCircleHorizontalSpacing: CGFloat = 52

  // MARK: - Properties

  private weak var checkStatusImageView: UIImageView!
  private weak var circleColorView: UIView!
  private weak var stickColorView: StickColorView!

  // MARK: - Initialize

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    checkStatusImageView.image = selected ?
    R.image.bottomSheet_ico_checked() : R.image.bottomSheet_ico_unChecked()
  }

  func setColor(_ color: UIColor) {
    circleColorView.backgroundColor = color
    stickColorView.setColor(color)
  }
}

private extension BottomSheetLabelColorTableViewCell {
  func setupViews() {
    self.checkStatusImageView = UIImageView().then {
      $0.image = R.image.bottomSheet_ico_unChecked()
      contentView.addSubview($0)
    }

    self.circleColorView = UIView().then {
      $0.t_cornerRadius(radius: Self.circleColorWidth / 2)
      contentView.addSubview($0)
    }

    self.stickColorView = StickColorView().then {
      contentView.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    checkStatusImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Self.superViewToImageViewHorizontalSpacing)
      $0.centerY.equalToSuperview()
    }

    circleColorView.snp.makeConstraints {
      $0.leading.equalTo(checkStatusImageView.snp.trailing)
        .offset(Self.imageViewToCircleHorizontalSpacing)
      $0.size.equalTo(CGSize(w: Self.circleColorWidth, h: Self.circleColorWidth))
      $0.centerY.equalToSuperview()
    }

    stickColorView.snp.makeConstraints {
      $0.leading.equalTo(circleColorView.snp.trailing).offset(28)
      $0.size.equalTo(CGSize(w: StickColorView.stickWidth, h: Self.circleColorWidth))
      $0.centerY.equalToSuperview()
    }
  }
}
