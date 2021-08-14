//
//  ProfileViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/14.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ProfileViewController: BaseViewController {

    // MARK: - Constants

    static let profileImageWidth: CGFloat = 140
    static let textFieldWidth: CGFloat = 335
    static let textFieldHeight: CGFloat = 48

    // MARK: - Properties

    private weak var profileImageView: UIImageView!
    private weak var editButton: UIButton!
    private weak var nameTextField: UITextField!

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    override func setupViews() {
        self.profileImageView = UIImageView().then {
            $0.image = R.image.home_icon_profile()
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.layer.shadowOffset = CGSize(w: 0, h: 2)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }

        self.editButton = UIButton().then {
            $0.setTitle(R.string.localizable.profileSettingTitle(), for: .normal)
            $0.setTitleColor(.t_tidiBlue(), for: .normal)
            $0.titleLabel?.font = UIFont.t_SB(14)
//            $0.titleLabel?.textColor = .t_tidiBlue()
            view.addSubview($0)
        }

        self.nameTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.profileNamePlaceHolder()
            $0.textAlignment = .center
            $0.backgroundColor = .white
            $0.font = .t_R(16)
            setupTextFieldLayer($0)
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(w: Self.profileImageWidth, h: Self.profileImageWidth))
        }

        editButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
        }

        nameTextField.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(56)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }
    }
}

private extension ProfileViewController {
    func setupTextFieldLayer(_ textFiled: UITextField) {
        textFiled.layer.cornerRadius = Self.textFieldHeight / 3
        textFiled.layer.shadowColor = UIColor.black.cgColor
        textFiled.layer.shadowOpacity = 0.5
        textFiled.layer.shadowOffset = CGSize(w: 0, h: 2)
        textFiled.layer.shadowRadius = Self.textFieldHeight / 3
        textFiled.layer.masksToBounds = false
    }
}
