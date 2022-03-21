//
//  SettingViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Foundation
import RxCocoa
import RxSwift

protocol SettingViewModelDelegate: AnyObject {
  func goToProfile()
  func goToSocialLogin()
}

enum SettingUserTapCase {
  case profile
  case socialLogin
}

class SettingViewModel: ViewModelType {
  
  // MARK: - Properties
  
  weak var delegate: SettingViewModelDelegate?
  
  var isOnAppLock: Bool = false
  
  enum Section: Int, CaseIterable {
    case account
    case dataManagement
    
    var numberOfRows: Int {
      switch self {
      case .account: return 2
      case .dataManagement: return 5
      }
    }
  }
  
  struct Input {
    let userTapEvent: Driver<SettingUserTapCase>
  }
  
  struct Output {
    let didUserTapCell: Driver<Void>
  }
  
  // MARK: - Methods
  
  func transform(_ input: Input) -> Output {
    let didUserTapCell = input.userTapEvent
      .do(onNext: { [weak self] userTapCase in
        switch userTapCase {
        case .profile:
          self?.delegate?.goToProfile()
        case .socialLogin:
          self?.delegate?.goToSocialLogin()
        }
      })
        .map { _ in }
    return Output(didUserTapCell: didUserTapCell)
  }
}
