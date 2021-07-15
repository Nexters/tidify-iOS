//
//  HomeViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftLinkPreview

protocol HomeViewModelDelegate: AnyObject {
    func pushRegisterView()
    func pushWebView()
}

class HomeViewModel {
    let imagePlaceholder = "https://via.placeholder.com/150"
    let swiftLinkPreview = SwiftLinkPreview()

    struct Input {
        let registerButtonTap: Driver<Void>
        let cellTapSubject: Observable<BookMark>
        let addListItemSubject: Observable<URL>
    }

    struct Output {
        let registerButtonTap: Driver<Void>
        let cellTapEvent: Driver<Void>
        let addListItem: Driver<BookMark?>
    }

    weak var delegate: HomeViewModelDelegate?

    var bookMarkList: [BookMark] = []

    func transfrom(_ input: Input) -> Output {
        let registerButtonTap = input.registerButtonTap
            .do(onNext: { [weak self] _ in
                self?.delegate?.pushRegisterView()
            })

        let cellTapEvent = input.cellTapSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] bookMark in
                self?.delegate?.pushWebView()
            })
            .map { _ in }

        let addListItem = input.addListItemSubject
            .flatMap { url -> Observable<BookMark?> in
                self.swiftLinkPreview.rx.preview(url: url)
                    .map { result -> BookMark in
                        let urlString = result.finalUrl?.absoluteString
                        let title = result.title ?? result.canonicalUrl ?? url.absoluteString
                        let thumbnail = URL(string: (result.image ?? result.icon) ?? self.imagePlaceholder)

                        return BookMark(urlString: urlString, title: title, thumbnail: thumbnail)
                    }
            }
            .catchErrorJustReturn(nil)
            .do(onNext: { [weak self] bookMark in
                if bookMark != nil {
                    self?.bookMarkList.append(bookMark!)
                }
            })
            .t_asDriverSkipError()

        return Output(registerButtonTap: registerButtonTap,
                      cellTapEvent: cellTapEvent,
                      addListItem: addListItem)
    }
}
