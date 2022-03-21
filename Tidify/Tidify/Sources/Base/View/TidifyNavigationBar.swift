//
//  TidifyNavigationBar.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/15.
//

import SnapKit
import Then
import UIKit

class TidifyNavigationBar: UIView {
  enum NavigationBarStyle {
    case `default`
    case rounded
    case folder

    var height: CGFloat {
      switch self {
      case .default: return 44
      case .rounded: return 144
      case .folder: return 144
      }
    }

    var leadingPadding: CGFloat {
      switch self {
      case .default: return 9
      case .rounded: return 28
      case .folder: return 20
      }
    }

    var trailingPadding: CGFloat {
      switch self {
      case .default: return 12
      case .rounded: return 20
      case .folder: return 20
      }
    }

    var bottomPadding: CGFloat {
      switch self {
      case .default: return 8
      case .rounded: return 18
      case .folder: return 24
      }
    }
  }

  // MARK: - Properties

  private weak var titleLabel: UILabel!
  private weak var leftButton: UIButton!
  private weak var rightStackView: UIStackView!

  private let navigationBarStyle: NavigationBarStyle

  // MARK: - Initialize

  init(_ navigationBarStyle: NavigationBarStyle,
       title: String? = nil,
       leftButton: UIButton,
       rightButtons: [UIButton] = []) {
    self.navigationBarStyle = navigationBarStyle
    super.init(frame: .zero)

    setupViews(navigationBarStyle,
               title: title,
               leftButton: leftButton,
               rightButtons: rightButtons)
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func setupViews(_ navigationBarStyle: NavigationBarStyle,
                  title: String?,
                  leftButton: UIButton,
                  rightButtons: [UIButton]) {
    self.backgroundColor = .white

    self.titleLabel = UILabel().then {
      $0.text = title ?? ""
      $0.font = .t_B(16)
      $0.textColor = .black
      addSubview($0)
    }

    self.leftButton = leftButton
    addSubview(leftButton)

    self.rightStackView = UIStackView().then {
      $0.axis = .horizontal
      $0.distribution = .fillEqually
      addSubview($0)
    }

    if !rightButtons.isEmpty {
      for rightButton in rightButtons {
        rightStackView.addArrangedSubview(rightButton)
        rightButton.snp.makeConstraints {
          $0.height.equalTo(40)
        }
      }
    }

    if navigationBarStyle == .rounded {
      self.t_cornerRadius([.bottomLeft, .bottomRight], radius: 18)
    }
  }

  func setupLayoutConstraints() {
    self.snp.makeConstraints {
      $0.leading.top.trailing.equalTo(safeAreaLayoutGuide)
      $0.height.equalTo(navigationBarStyle.height)
    }

    leftButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(navigationBarStyle.leadingPadding)
      $0.bottom.equalToSuperview().inset(navigationBarStyle.bottomPadding)
      $0.size.equalTo(CGSize(w: 40, h: 40))
    }

    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(leftButton)
    }

    rightStackView.snp.makeConstraints {
      $0.centerY.equalTo(leftButton)
      $0.trailing.equalToSuperview().inset(navigationBarStyle.trailingPadding)
      $0.height.equalTo(40)
      $0.width.equalTo(navigationBarStyle == .folder ? 40 : 75)
    }
  }
}
