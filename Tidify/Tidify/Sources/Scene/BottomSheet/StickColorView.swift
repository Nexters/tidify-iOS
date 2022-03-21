//
//  StickColorView.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/28.
//

import SnapKit
import Then
import UIKit

class StickColorView: UIView {

  // MARK: - Constnats

  static let leftColorViewWidth: CGFloat = 9
  static let stickWidth: CGFloat = 180
  static let stickHeight: CGFloat = 30

  // MARK: - Properties

  private weak var leftColorView: UIView!
  private weak var whiteStickView: UIView!

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func setColor(_ color: UIColor) {
    self.leftColorView.backgroundColor = color
  }
}

private extension StickColorView {
  func setupViews() {
    self.leftColorView = UIView().then {
      $0.t_cornerRadius([.topLeft, .bottomLeft], radius: 8)
      addSubview($0)
    }

    self.whiteStickView = UIView().then {
      $0.backgroundColor = .white
      $0.t_cornerRadius([.topRight, .bottomRight], radius: 8)
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.layer.borderWidth = 1
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    leftColorView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.size.equalTo(CGSize(w: Self.leftColorViewWidth, h: Self.stickHeight))
    }

    whiteStickView.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
      $0.leading.equalTo(leftColorView.snp.trailing)
      $0.size.equalTo(CGSize(w: Self.stickWidth - Self.leftColorViewWidth,
                             h: Self.stickHeight))
    }
  }
}
