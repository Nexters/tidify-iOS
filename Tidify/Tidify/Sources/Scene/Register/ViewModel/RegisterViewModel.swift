//
//  RegisterViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation
import RxCocoa
import RxSwift
import LinkPresentation

class RegisterViewModel: ViewModelType {

    // MARK: - Properties

    struct Input {
        let urlInputText: Observable<String?>
        let bookMarkNameInputText: Observable<String?>
        let tagInputText: Observable<String?>
        let registerButtonTap: Observable<Void>
    }

    struct Output {
        let didRegisterButtonTap: Driver<Void>
    }

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didRegisterButtonTap = input.registerButtonTap.t_asDriverSkipError()
            .withLatestFrom(Driver.combineLatest(input.urlInputText.t_asDriverSkipError(),
                                                 input.bookMarkNameInputText.t_asDriverSkipError(),
                                                 input.tagInputText.t_asDriverSkipError()))
            .flatMapLatest { urlString, _, _ -> Driver<(String, String)> in
                let urlString = urlString
                var urlTitle = ""
                let metadataProvider = LPMetadataProvider()

                guard let urlString = urlString, let url = URL(string: urlString) else {
                    return .just((urlString ?? "", urlTitle))
                }

                metadataProvider.startFetchingMetadata(for: url, completionHandler: { metaData, error in
                    guard error != nil, let title = metaData?.title else {
                        return
                    }

                    urlTitle = title
                })

                return .just((urlString, urlTitle))
            }
            .flatMapLatest { urlString, urlTItle in
                return ApiProvider.request(BookMarkAPI.createBookMark(title: urlTItle, url: urlString))
                    .t_asDriverSkipError()
                    .map { _ in }
            }

        return Output(didRegisterButtonTap: didRegisterButtonTap.map { _ in })
    }
}
