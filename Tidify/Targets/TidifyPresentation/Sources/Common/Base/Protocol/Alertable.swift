//
//  Alertable.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/08/04.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

@frozen
internal enum AlertType: CaseIterable {
  case loginError
  case deleteBookmark
  case deleteFolder
  case removeImageCache
  case removeAllCache
  case logout
  case signOut
  case folderCreationError
  case folderFetchError
  case bookmarkCreationError
  case bookmarkFetchError
  case copiedShareFolderScheme

  var title: String {
    switch self {
    case .deleteBookmark: return "북마크 삭제 주의사항"
    case .deleteFolder: return "폴더 삭제"
    case .removeImageCache: return "이미지 캐시 정리 안내"
    case .removeAllCache: return "모든 캐시 정리 안내"
    case .logout: return "로그아웃 안내"
    case .signOut: return "회원탈퇴"
    case .loginError: return "소셜 로그인에 실패했습니다"
    case .folderCreationError: return "저장에 실패했습니다"
    case .folderFetchError: return "폴더를 불러올 수 없습니다"
    case .bookmarkCreationError: return "저장에 실패했습니다"
    case .bookmarkFetchError: return "북마크를 불러올 수 없습니다"
    case .copiedShareFolderScheme: return "폴더 공유"
    }
  }

  var message: String {
    switch self {
    case .deleteBookmark: return "삭제한 북마크는 복구할 수 없습니다"
    case .deleteFolder: return "정리해놓은 폴더가 사라질텐데\n정말 괜찮으신가요?"
    case .removeImageCache: return "저장한 북마크가 많거나 앱이 느려질 때 도움이 될 수 있습니다"
    case .removeAllCache: return "디바이스 저장공간이 부족할 때 도움이 될 수 있습니다"
    case .logout: return "지금까지 모은 북마크는 계정에 저장됩니다"
    case .signOut: return "지금까지 모은 북마크는 모두 삭제되며 되돌릴 수 없어요"
    case .loginError: return "네트워크 연결상태 혹은 선택한 플랫폼을 확인해주세요"
    case .folderCreationError: return "네트워크 연결상태 혹은 폴더 제목을 확인해주세요"
    case .folderFetchError, .bookmarkFetchError: return "네트워크 연결상태를 확인 후 다시 접속해주세요"
    case .bookmarkCreationError: return "네트워크 연결상태 혹은 URL을 확인해주세요"
    case .copiedShareFolderScheme: return "URL을 복사했어요"
    }
  }

  var leftButtonTitle: String { "취소" }

  var rightButtonTitle: String { "실행" }

  var okButtonTitle: String { "확인" }
}

protocol Alertable {}

extension Alertable where Self: UIViewController {
  func presentAlert(
    type: AlertType,
    leftButtonTapHandler: (() -> Void)? = nil,
    rightButtonTapHandler: (() -> Void)? = nil
  ) {
    let alertController = UIAlertController(
      title: type.title,
      message: type.message,
      preferredStyle: .alert
    )

    if leftButtonTapHandler.isNil && rightButtonTapHandler.isNil {
      alertController.addAction(UIAlertAction(title: type.okButtonTitle, style: .default))
    } else {
      alertController.addAction(UIAlertAction(title: type.leftButtonTitle, style: .cancel, handler: { _ in
        leftButtonTapHandler?()
      }))
      alertController.addAction(UIAlertAction(title: type.rightButtonTitle, style: .default, handler: { _ in
        rightButtonTapHandler?()
      }))
    }

    present(alertController, animated: true)
  }
}
