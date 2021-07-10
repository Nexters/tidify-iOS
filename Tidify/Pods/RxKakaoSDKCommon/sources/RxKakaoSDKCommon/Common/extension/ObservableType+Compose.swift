//  Copyright 2019 Kakao Corp.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import Foundation
import RxSwift

public struct ComposeTransformer<T, R> {
    let transformer: (Observable<T>) -> Observable<R>
    public init(transformer: @escaping (Observable<T>) -> Observable<R>) {
        self.transformer = transformer
    }
    
    public func call(_ observable: Observable<T>) -> Observable<R> {
        return transformer(observable)
    }
}

extension ObservableType {
    public func compose<T>(_ transformer: ComposeTransformer<Element, T>) -> Observable<T> {
        return transformer.call(self.asObservable())
    }
}
