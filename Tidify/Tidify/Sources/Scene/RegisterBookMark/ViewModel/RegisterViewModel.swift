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
        let bookMarkContent: Driver<(String, String?)>
        let registerButtonTap: Driver<Void>
    }

    struct Output {
        let didRegisterButtonTap: Driver<Void>
    }

    func transform(_ input: Input) -> Output {
        let didRegisterButtonTap = input.registerButtonTap
            .withLatestFrom(input.bookMarkContent)
            .flatMapLatest { [weak self] link, tag -> Driver<Void> in
                return ApiProvider.request(BookMarkAPI.createBookMark(id: 1, title: "TMP TITLE", url: link))
                    .t_asDriverSkipError()
                    .map { _ in }
            }

        return Output(didRegisterButtonTap: didRegisterButtonTap)
    }
}
