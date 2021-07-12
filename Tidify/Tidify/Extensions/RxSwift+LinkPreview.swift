//
//  RxSwift+LinkPreview.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/11.
//

import RxSwift
import SwiftLinkPreview

extension Reactive where Base: SwiftLinkPreview {
    func preview(url: URL?) -> Observable<Response> {
        return Observable.create { observer in
            guard let url = url else {
                observer.onCompleted()
                return Disposables.create()
            }

            base.preview(String(describing: url), onSuccess: { result in
                    observer.onNext(result)
                    observer.onCompleted()
                },
                onError: { error in
                    observer.onError(error)
                    observer.onCompleted()
                })

            return Disposables.create()
        }
    }
}
