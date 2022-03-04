//
//  RegisterViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftLinkPreview

class RegisterViewModel: ViewModelType {
    // (url, title, og_img_url, tags)
    typealias PreviewResponse = (String, String?, String?, String?)

    // MARK: - Properties

    struct Input {
        let urlInputText: Driver<String>
        let bookMarkNameInputText: Driver<String?>
        let tagInputText: Driver<String>
        let registerButtonTap: Driver<Void>
    }

    struct Output {
        let didSaveBookMark: Driver<Void>
        let didReceivePreviewResponse: Driver<Void>
    }

    private let previewResponseSubject = PublishSubject<PreviewResponse>()

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didReceivePreviewResponse = input.registerButtonTap.t_asDriverSkipError()
            .withLatestFrom(Driver.combineLatest(
                input.urlInputText.t_asDriverSkipError(),
                input.bookMarkNameInputText.t_asDriverSkipError().startWith(""),
                input.tagInputText.t_asDriverSkipError())
            )
            .map { urlString, bookMarkName, tag in
                let linkPreview = SwiftLinkPreview(session: .shared,
                                                   workQueue: SwiftLinkPreview.defaultWorkQueue,
                                                   responseQueue: .main,
                                                   cache: DisabledCache.instance)
                var response: PreviewResponse = (urlString, nil, nil, nil)

                linkPreview.preview(urlString, onSuccess: { [weak self] previewResponse in
                    guard let bookMarkName = bookMarkName else {
                        return
                    }
                    response = (urlString,
                                bookMarkName.isEmpty ?
                                previewResponse.title : bookMarkName, previewResponse.icon, tag)
                    self?.previewResponseSubject.onNext(response)
                }, onError: { error in
                    print("[ERROR] \(error.localizedDescription)")
                    response = (urlString, nil, nil, nil)
                    self.previewResponseSubject.onNext(response)
                })
            }

        let didSaveBookMark = previewResponseSubject.t_asDriverSkipError()
            .flatMapLatest { urlString, bookMarkTitle, ogImageUrl, tag -> Driver<Void> in
                return APIProvider.request(BookMarkAPI.createBookMark(url: urlString,
                                                                      title: bookMarkTitle,
                                                                      ogImageUrl: ogImageUrl,
                                                                      tags: tag))
                    .t_asDriverSkipError()
                    .map { _ in }
            }

        return Output(didSaveBookMark: didSaveBookMark,
                      didReceivePreviewResponse: didReceivePreviewResponse)
    }
}
