//
//  BaseView.swift
//  Tidify
//
//  Created by Ian on 2022/06/26.
//

import UIKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {

  }

  func setupLayoutConstraints() {

  }
}
