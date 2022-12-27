//
//  AlertPresenter.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/21.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

typealias ButtonAction = () -> Void?

final class AlertPresenter: UIViewController {

  enum AlertType {
    case deleteBookmark
    case deleteFolder
    case removeImageCache
    case removeAllCache
    case logout
    case signOut

    var title: String {
      switch self {
      case .deleteBookmark: return "북마크가 없어져요"
      case .deleteFolder: return "폴더 삭제"
      case .removeImageCache: return "이미지 캐시 정리"
      case .removeAllCache: return "모든 캐시 정리"
      case .logout: return "로그아웃"
      case .signOut: return "회원탈퇴"
      }
    }

    var description: String {
      switch self {
      case .deleteBookmark: return "이 글은 더 이상 볼 수 없을텐데\n정말 삭제하시겠어요?"
      case .deleteFolder: return "정리해놓은 폴더가 사라질텐데\n정말 괜찮으신가요?"
      case .removeImageCache: return "북마크가 많아졌을 때\n깔끔하게 정리해드릴게요!"
      case .removeAllCache: return "디바이스에 저장공간이 부족할 때\n깔끔하게 도와드릴게요!"
      case .logout: return "지금까지 모아놓은 북마크는\n계정에 저장해 놓을게요!"
      case .signOut: return "사라진 북마크는 되돌릴 수 없어요.\n그래도 괜찮으신가요?"
      }
    }

    var leftButtonTitle: String {
      switch self {
      case .removeImageCache, .removeAllCache:
        return "괜찮아요"
      case .logout, .signOut, .deleteBookmark, .deleteFolder:
        return "다음에요"
      }
    }

    var rightButtonTitle: String {
      switch self {
      case .removeImageCache, .removeAllCache:
        return "지금 필요해요"
      case .logout:
        return "나갈래요"
      case .signOut:
        return "탈퇴할래요"
      case .deleteBookmark, .deleteFolder:
        return "삭제할래요"
      }
    }
  }

  // MARK: - Properties
  private let containerView: UIView = .init()
  private let titleLabel: UILabel = .init()
  private let descriptionLabel: UILabel = .init()
  private let buttonStackView: UIStackView = .init()
  private let leftButton: UIButton = .init()
  private var rightButton: UIButton = .init()
  
  private var leftButtonAction: ButtonAction?
  private var rightButtonAction: ButtonAction?
  private let disposeBag: DisposeBag = .init()
  private var alertType: AlertType? {
    didSet {
      titleLabel.text = alertType?.title
      descriptionLabel.text = alertType?.description
      leftButton.setTitle(alertType?.leftButtonTitle, for: .normal)
      rightButton.setTitle(alertType?.rightButtonTitle, for: .normal)
    }
  }

  // MARK: - Initializer
  init() {
    super.init(nibName: nil, bundle: nil)

    self.modalPresentationStyle = .overFullScreen
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()

    leftButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { owner, _ in
        owner.leftButtonAction?()
        owner.dismiss()
      })
      .disposed(by: disposeBag)

    rightButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { owner, _ in
        owner.rightButtonAction?()
        owner.dismiss()
      })
      .disposed(by: disposeBag)
  }

  func present(
    on viewController: UIViewController,
    alertType: AlertType,
    leftButtonAction: ButtonAction? = nil,
    rightButtonAction: ButtonAction? = nil
  ) {
    self.alertType = alertType
    self.leftButtonAction = leftButtonAction
    self.rightButtonAction = rightButtonAction

    viewController.present(self, animated: false) {
      UIView.animate(withDuration: 0.5, animations: {
        self.containerView.alpha = 1
        self.view.alpha = 1
      })
    }
  }
}

// MARK: - Private Extension
private extension AlertPresenter {
  func setupUI() {
    view.addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(descriptionLabel)
    containerView.addSubview(buttonStackView)
    buttonStackView.addArrangedSubview(leftButton)
    buttonStackView.addArrangedSubview(rightButton)

    view.backgroundColor = .black.withAlphaComponent(0.4)

    view.alpha = 0
    containerView.alpha = 0

    containerView.do {
      $0.backgroundColor = .white
      $0.cornerRadius(radius: 20)
    }

    titleLabel.do {
      $0.textColor = .t_tidiBlue00()
      $0.font = .systemFont(ofSize: 20, weight: .bold)
      $0.textAlignment = .center
    }

    descriptionLabel.do {
      $0.textColor = .black
      $0.font = .systemFont(ofSize: 16)
      $0.textAlignment = .center
      $0.numberOfLines = 0
    }

    buttonStackView.do {
      $0.distribution = .fillEqually
      $0.axis = .horizontal
    }

    leftButton.do {
      $0.backgroundColor = .t_indigo00()
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 16 ,weight: .bold)
    }

    rightButton.do {
      $0.backgroundColor = .t_tidiBlue00()
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }

    containerView.snp.makeConstraints {
      $0.size.equalTo(CGSize(w: 272, h: 200))
      $0.center.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(36)
      $0.centerX.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.bottom.lessThanOrEqualTo(buttonStackView.snp.top)
    }

    buttonStackView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(56)
      $0.bottom.equalToSuperview()
    }
  }

  func dismiss() {
    UIView.animate(withDuration: 0.5, animations: {
      self.containerView.alpha = 0
      self.view.alpha = 0
    }, completion: { flag in
      if flag {
        self.dismiss(animated: false)
      }
    })
  }
}
