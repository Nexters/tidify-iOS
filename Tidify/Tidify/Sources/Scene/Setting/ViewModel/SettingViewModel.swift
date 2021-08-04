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
    func goToInterLink()
    func goToAuthMethod()
}

enum SettingUserTapCase {
    case profile
    case interLink
    case authMethod
}

class SettingViewModel: ViewModelType {

    // MARK: - Properties

    weak var delegate: SettingViewModelDelegate?

    var isOnAppLock: Bool = false

    enum Section: Int, CaseIterable {
        case account
        case security
    }

    struct Input {
        let userTapEvent: Driver<SettingUserTapCase>
        let appLockTapEvent: Driver<Void>
    }

    struct Output {
        let didUserTapCell: Driver<Void>
        let didUserTapAppLock: Driver<Void>
    }

    // MARK: - Methods
    func transform(_ input: Input) -> Output {
        let didUserTapCell = input.userTapEvent
            .do(onNext: { [weak self] userTapCase in
                switch userTapCase {
                case .profile:
                    self?.delegate?.goToProfile()
                case .interLink:
                    self?.delegate?.goToInterLink()
                case .authMethod:
                    self?.delegate?.goToAuthMethod()
                }
            })
            .map { _ in }

        let didUserTapAppLock = input.appLockTapEvent
            .do(onNext: { [weak self] _ in
                self?.isOnAppLock.toggle()
            })

        return Output(didUserTapCell: didUserTapCell,
                      didUserTapAppLock: didUserTapAppLock)
    }
}
