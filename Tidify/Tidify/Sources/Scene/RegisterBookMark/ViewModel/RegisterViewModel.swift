//
//  RegisterViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation
import RxCocoa
import RxSwift

class RegisterViewModel: ViewModelType {

    // MARK: - Properties

    struct Input {
        let registerButtonTap: Observable<String?>
    }

    struct Output {
        let didRegisterButtonTap: Driver<Void>
    }

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didRegisterButtonTap = input.registerButtonTap.t_asDriverSkipError()
            .flatMapLatest { newUrl -> Driver<Void> in
                if newUrl != nil {
                    return ApiProvider.request(BookMarkAPI.createBookMark(id: 1, title: "TMP TITLE", url: newUrl!))
                        .t_asDriverSkipError()
                        .map { _ in }
                }

                return .empty()
            }

        return Output(didRegisterButtonTap: didRegisterButtonTap)
    }
}
