//
//  MainViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift

class MainViewModel {
    struct Input {
        let cellTapSubject: Observable<BookMark>
        let addListItemSubject: Observable<BookMark>
    }

    struct Output {
        let cellTapEvent: Driver<Void>
        let addListItem: Driver<BookMark>
    }

    var mockUpData = [
        BookMark(urlString: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=227&oid=366&aid=0000745596", title: "FT \"日 소프트뱅크, 야놀자에 1조원 투자 계획\""),
        BookMark(urlString: "https://news.naver.com/main/read.naver?mode=LSD&mid=shm&sid1=103&oid=422&aid=0000494233", title: "BTS 신곡, 92개국 아이튠즈 차트 정상"),
        BookMark(urlString: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=731&oid=014&aid=0004672150", title: "애플 아이패드 프로 11형에도 미니LED탑재하나"),
        BookMark(urlString: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=228&oid=001&aid=0012516598", title: "세계 1천만 명이 앓는 파킨슨병, 마침내 발병 원인 밝혀냈다"),
    ]

    func transfrom(_ input: Input) -> Output {
        let cellTapEvent = input.cellTapSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] bookMark in
                print("🎱🎱🎱 \(bookMark) didTap")
            })
            .map { _ in }
        
        let addListItem = input.addListItemSubject
            .t_asDriverSkipError()
            .do(onNext: { [weak self] bookMark in
                self?.mockUpData.append(bookMark)
            })

        return Output(cellTapEvent: cellTapEvent, addListItem: addListItem)
    }
}
