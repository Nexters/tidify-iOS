//
//  MainViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import SwiftLinkPreview
import RxCocoa
import RxSwift

class MainViewModel {

    let imagePlaceholder = "https://via.placeholder.com/150"
    let swiftLinkPreview = SwiftLinkPreview()

    struct Input {
        let cellTapSubject: Observable<BookMark>
        let addListItemSubject: Observable<URL>
    }

    struct Output {
        let cellTapEvent: Driver<Void>
        let addListItem: Driver<BookMark?>
    }

    var bookMarkList: [BookMark] = []

    func transfrom(_ input: Input) -> Output {
        let cellTapEvent = input.cellTapSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] bookMark in
                print("🎱🎱🎱 \(bookMark) didTap")
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

        return Output(cellTapEvent: cellTapEvent, addListItem: addListItem)
    }
}
