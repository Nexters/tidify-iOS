//
//  RegisterViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation
import LinkPresentation
import RxCocoa
import RxSwift

class RegisterViewModel: ViewModelType {

    // MARK: - Properties

    struct Input {
        let urlInputText: Driver<String?>
        let bookMarkNameInputText: Driver<String?>
        let tagInputText: Driver<String?>
        let registerButtonTap: Driver<Void>
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

                // 추후 LPMetaDataProvider 기반 icon, title 뽑아오는 로직 작성 필요
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
