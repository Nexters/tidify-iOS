//
//  MainViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import Foundation

class MainViewModel {
    struct Input {
        let cellTapSubject: Observable<BookMark>
    }

    struct Output {
        let cellTapEvent: Driver<Void>
    }

    let mockUpData = [
        BookMark(urlString: "www.naver.com", title: "[단독] 국내 첫 전자증명서인증사업자는 네이버, 토스, 페이코, 뱅크샐러드1"),
        BookMark(urlString: "www.naver.com", title: "[단독] 국내 첫 전자증명서인증사업자는 네이버, 토스, 페이코, 뱅크샐러드2"),
        BookMark(urlString: "www.naver.com", title: "[단독] 국내 첫 전자증명서인증사업자는 네이버, 토스, 페이코, 뱅크샐러드3"),
        BookMark(urlString: "www.naver.com", title: "[단독] 국내 첫 전자증명서인증사업자는 네이버, 토스, 페이코, 뱅크샐러드4")
    ]

    func transfrom(_ input: Input) -> Output {

        let cellTapEvent = input.cellTapSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] bookMark in
                print("🎱🎱🎱 \(bookMark) didTap")
            })
            .map { _ in }

        return Output(cellTapEvent: cellTapEvent)
    }
}
