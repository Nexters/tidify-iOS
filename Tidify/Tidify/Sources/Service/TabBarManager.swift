//
//  TabBarManager.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/09.
//

import Foundation
import RxSwift

class TabBarManager {

    static let shared = TabBarManager()

    enum ManagerBehavior: String {
        case show = "showTabBar"
        case hide = "hideTabBar"
    }

    let showTabBarSubject = PublishSubject<Void>()
    let hideTabBarSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    private init() {
        showTabBarSubject.t_asDriverSkipError()
            .drive(onNext: { _ in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ManagerBehavior.show.rawValue), object: nil)
            })
            .disposed(by: disposeBag)

        hideTabBarSubject.t_asDriverSkipError()
            .drive(onNext: { _ in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ManagerBehavior.hide.rawValue), object: nil)
            })
            .disposed(by: disposeBag)
    }
}
