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

class HomeViewModel: ViewModelType {

    // MARK: - Properties

    let imagePlaceholder = "https://via.placeholder.com/150"
    let swiftLinkPreview = SwiftLinkPreview()

    struct Input {
        let registerButtonTap: Driver<Void>
        let cellTapSubject: Observable<BookMark>
        let addListItemSubject: Observable<URL>
    }

    struct Output {
        let didReceiveBookMarks: Driver<Void>
        let registerButtonTap: Driver<Void>
        let cellTapEvent: Driver<Void>
        let addListItem: Driver<BookMark?>
    }

    weak var delegate: HomeViewModelDelegate?

    var bookMarkList: [BookMark] = []

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didReceiveBookMarks = Driver.just(())
            .flatMapLatest { _ -> Driver<BookMarkListDTO> in
                return ApiProvider.request(BookMarkAPI.getBookMarkList(id: 1))
                    .map(BookMarkListDTO.self)
                    .asDriver(onErrorRecover: { error in
                        print(error.localizedDescription)
                        return .empty()
                    })
            }
            .do(onNext: { [weak self] bookMarkListDTO in
                self?.bookMarkList = bookMarkListDTO.bookMarks.map { $0.toEntity() }
            })
            .map { _ in }

        let registerButtonTap = input.registerButtonTap
            .do(onNext: { [weak self] _ in
                self?.delegate?.pushRegisterView()
            })

        let cellTapEvent = input.cellTapSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] _ in
                self?.delegate?.pushWebView()
            })
            .map { _ in }

        let addListItem = input.addListItemSubject
            .flatMap { url -> Observable<BookMark?> in
                self.swiftLinkPreview.rx.preview(url: url)
                    .map { result -> BookMark in
                        let urlString = result.finalUrl?.absoluteString ?? url.absoluteString
                        let title = result.title ?? result.canonicalUrl ?? url.absoluteString

                        return BookMark(createdAt: "2021-07-17T11:38:29.029Z",
                                        updatedAt: "2021-07-17T11:38:29.029Z",
                                        id: 1,
                                        memberId: 1,
                                        urlString: urlString,
                                        title: title)
                    }
            }
            .catchErrorJustReturn(nil)
            .do(onNext: { [weak self] bookMark in
                if bookMark != nil {
                    self?.bookMarkList.append(bookMark!)
                }
            })
            .t_asDriverSkipError()

        return Output(didReceiveBookMarks: didReceiveBookMarks,
                      registerButtonTap: registerButtonTap,
                      cellTapEvent: cellTapEvent,
                      addListItem: addListItem)
    }
}
