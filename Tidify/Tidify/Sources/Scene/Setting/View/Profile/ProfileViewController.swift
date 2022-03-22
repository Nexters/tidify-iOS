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

  weak var coordinator: ProfileCoordinator?

  private weak var profileImageView: UIImageView!
  private weak var editButton: UIButton!
  private weak var nameTextField: UITextField!
  private let imagePicker = UIImagePickerController()
  private let leftButton: UIButton!
  private let rightButton: UIButton!

  private let saveDataSubject: PublishSubject<Void>
  private let disposeBag = DisposeBag()

  lazy var navigationBar = TidifyNavigationBar(.default,
                                               leftButton: leftButton,
                                               rightButtons: [rightButton])

  // MARK: - Initialize
  init(_ saveDataSubject: PublishSubject<Void>, leftButton: UIButton, rightButton: UIButton) {
    self.saveDataSubject = saveDataSubject
    self.leftButton = leftButton
    self.rightButton = rightButton

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    editButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.showLibrary()
      })
      .disposed(by: disposeBag)

    saveDataSubject.t_asDriverSkipError()
      .drive(onNext: { [weak self] _ in
        self?.saveProfileData()
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Methods

  override func setupViews() {
    setupNavigationBar()

    view.backgroundColor = .white

    self.profileImageView = UIImageView().then {
      $0.image = R.image.home_icon_profile()
      $0.layer.shadowColor = UIColor.black.cgColor
      $0.layer.shadowOpacity = 0.5
      $0.layer.shadowOffset = CGSize(w: 0, h: 2)
      $0.layer.shadowRadius = Self.profileImageWidth / 2
      $0.layer.masksToBounds = false
      view.addSubview($0)
    }

    self.editButton = UIButton().then {
      $0.setTitle(R.string.localizable.profileSettingTitle(), for: .normal)
      $0.setTitleColor(.t_tidiBlue(), for: .normal)
      $0.titleLabel?.font = UIFont.t_SB(14)
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

    self.imagePicker.delegate = self
  }

  override func setupLayoutConstraints() {
    profileImageView.snp.makeConstraints {
      //            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
      $0.top.equalTo(navigationBar).offset(50)
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    guard let image = info[.originalImage] as? UIImage else {
      return
    }

    self.profileImageView.image = image
    dismiss(animated: true, completion: nil)
  }
}

private extension ProfileViewController {
  func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
  }

  func setupTextFieldLayer(_ textFiled: UITextField) {
    textFiled.layer.cornerRadius = Self.textFieldHeight / 3
    textFiled.layer.shadowColor = UIColor.black.cgColor
    textFiled.layer.shadowOpacity = 0.5
    textFiled.layer.shadowOffset = CGSize(w: 0, h: 2)
    textFiled.layer.shadowRadius = Self.textFieldHeight / 3
    textFiled.layer.masksToBounds = false
  }

  func showLibrary() {
    imagePicker.sourceType = .photoLibrary
    present(imagePicker, animated: true, completion: nil)
  }

  func saveProfileData() {
    guard let imageData = self.profileImageView.image?.pngData(),
          let nameText = self.nameTextField.text else {
            return
          }

    UserDefaults.standard.setValue(imageData, forKey: UserDefaultManager.userImageData.rawValue)
    UserDefaults.standard.setValue(nameText, forKey: UserDefaultManager.userNameString.rawValue)
  }
}
