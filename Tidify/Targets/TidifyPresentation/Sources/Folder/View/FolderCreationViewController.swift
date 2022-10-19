//
//  FolderCreationViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/19.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import ReactorKit
import SnapKit

final class FolderCreationViewController: UIViewController {

  // MARK: - Properties
  private var titleLabel: UILabel = .init()
  private var titleTextField: UITextField = .init()
  private var colorLabel: UILabel = .init()
  private var colorTextField: TidifyRightButtonTextField = .init(
    placeholder: "라벨을 달아봐요!",
    rightButtonImage: .init(named: "icon_arrowDown_gray")
  )
  private var createFolderButton: UIButton = .init()
  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }
}

// MARK: - Private
private extension FolderCreationViewController {
  func setupUI() {
    let sidePadding: CGFloat = 20

    title = "폴더 생성"
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.title = ""

    view.addSubview(titleLabel)
    view.addSubview(titleTextField)
    view.addSubview(colorLabel)
    view.addSubview(colorTextField)
    view.addSubview(createFolderButton)

    titleLabel = setGuideLabel(titleLabel, title: "폴더 이름")
    titleTextField = setTextField(titleTextField, placeholder: "어떤 북마크를 모을까요?")
    colorLabel = setGuideLabel(colorLabel, title: "라벨")

    createFolderButton.do {
      $0.setTitle("저장", for: .normal)
      $0.titleLabel?.font = .t_SB(18)
      $0.setTitleColor(.systemGray2, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.isEnabled = false
      $0.cornerRadius(radius: 16)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    titleTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    colorLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    colorTextField.snp.makeConstraints {
      $0.top.equalTo(colorLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    createFolderButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(Self.viewHeight * 0.068)
    }
  }

  func setGuideLabel(_ label: UILabel, title: String) -> UILabel {
    label.do {
      $0.text = title
      $0.font = .t_EB(16)
      $0.textColor = .black
    }

    return label
  }

  func setTextField(_ textField: UITextField, placeholder: String) -> UITextField {
    let attrString: NSAttributedString = .init(
      string: placeholder,
      attributes: [.foregroundColor: UIColor.gray]
    )

    textField.do {
      $0.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.attributedPlaceholder = attrString
      $0.backgroundColor = .white
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.t_borderColor().cgColor
      $0.cornerRadius(radius: 16)
      $0.font = .t_SB(16)
      $0.textColor = .black
    }

    return textField
  }
}

private extension FolderCreationViewController {
  var isEnableCreateFolderButtonBinder: Binder<Bool> {
    return .init(self) { owner, isEnable in
      owner.createFolderButton.backgroundColor = isEnable ? .t_tidiBlue00() : .clear
      owner.createFolderButton.setTitleColor(isEnable ? .white : .systemGray2, for: .normal)
      owner.createFolderButton.layer.borderColor = isEnable ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
    }
  }
}
