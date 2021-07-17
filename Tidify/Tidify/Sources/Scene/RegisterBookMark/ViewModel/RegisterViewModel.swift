//
//  RegisterViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel {
    struct Input {
        let registerButtonTap: Observable<Void>
    }

    struct Output {
        let didRegisterButtonTap: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let didRegisterButtonTap = input.registerButtonTap.t_asDriverSkipError()
            .flatMapLatest { _ -> Driver<Void> in
                return ApiProvider.request(BookMarkAPI.createBookMark(id: 1, title: "TMP TITLE", url: "https://www.naver.com"))
                    .t_asDriverSkipError()
                    .map { _ in }
            }

        return Output(didRegisterButtonTap: didRegisterButtonTap)
    }
}
