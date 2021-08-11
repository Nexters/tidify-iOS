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
        let cellTapSubject: Driver<BookMark>
    }

    struct Output {
        let didReceiveBookMarks: Driver<Void>
        let cellTapEvent: Driver<Void>
    }

    weak var delegate: HomeViewModelDelegate?

    var bookMarkList: [BookMark] = []

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didReceiveBookMarks = Driver.just(())
            .flatMapLatest { _ -> Driver<BookMarkListDTO> in
                return ApiProvider.request(BookMarkAPI.getBookMarkList(id: 1))
                    .map(BookMarkListDTO.self)
                    .t_asDriverSkipError()
            }
            .do(onNext: { [weak self] bookMarkListDTO in
                self?.bookMarkList = bookMarkListDTO.bookMarks.map { $0.toEntity() }
            })
            .map { _ in }

        let cellTapEvent = input.cellTapSubject
            .do(onNext: { [weak self] _ in
                self?.delegate?.pushWebView()
            })
            .map { _ in }

        return Output(didReceiveBookMarks: didReceiveBookMarks,
                      cellTapEvent: cellTapEvent)
    }
}
