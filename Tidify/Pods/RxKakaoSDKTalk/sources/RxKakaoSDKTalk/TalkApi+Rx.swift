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
import Alamofire
import RxAlamofire

import KakaoSDKCommon
import RxKakaoSDKCommon

import KakaoSDKAuth
import RxKakaoSDKAuth

import KakaoSDKTalk
import KakaoSDKTemplate

extension TalkApi: ReactiveCompatible {}

/// `TalkApi`의 ReactiveX 확장입니다.
///
/// 아래는 talk/profile을 호출하는 간단한 예제입니다.
///
///     TalkApi.shared.rx.profile()
///        .retryWhen(Auth.shared.rx.incrementalAuthorizationRequired())
///        .subscribe(onSuccess:{ (profile) in
///            print(profile)
///        }, onError: { (error) in
///            print(error)
///        })
///        .disposed(by: <#Your DisposeBag#>)
extension Reactive where Base: TalkApi {
   
    // MARK: Profile
    
    /// 로그인된 사용자의 카카오톡 프로필 정보를 얻을 수 있습니다.
    /// - seealso: `TalkProfile`
    public func profile() -> Single<TalkProfile> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.talkProfile))
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            
//            .map({ (response, data) -> TalkProfile in
//                return try SdkJSONDecoder.custom.decode(TalkProfile.self, from: data)
//            })
            .asSingle()
    }
    
    // MARK: Memo

    /// 카카오 디벨로퍼스에서 생성한 서비스만의 커스텀 메시지 템플릿을 사용하여, 카카오톡의 "나와의 채팅방"으로 메시지를 전송합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/latest/ko/message/ios#create-message 을 참고하시기 바랍니다.
    public func sendCustomMemo(templateId: Int64, templateArgs: [String:String]? = nil) -> Completable {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.customMemo), parameters: ["template_id":templateId, "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .do (
                onNext: { _ in
                    SdkLog.i("completable:\n success\n\n" )
                }
            )
            .ignoreElements()
    }

    /// 기본 템플릿을 이용하여, 카카오톡의 "나와의 채팅방"으로 메시지를 전송합니다.
    /// - seealso: [Template](../../KakaoSDKTemplate/Protocols/Templatable.html)
    public func sendDefaultMemo(templatable: Templatable) -> Completable {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.defaultMemo), parameters: ["template_object":templatable.toJsonObject()?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .do (
                onNext: { _ in
                    SdkLog.i("completable:\n success\n\n" )
                }
            )
            .ignoreElements()
    }
    
//    public func defaultMemo(templateObject: [String:Any]) -> Completable {
//        return self.responseData(.post, Urls.defaultMemo, parameters: ["template_object":templateObject.toJsonString()].filterNil())
//            .compose(composeTransformerCheckApiErrorForKApi)
//            .ignoreElements()
//    }

    /// 지정된 URL을 스크랩하여, 카카오톡의 "나와의 채팅방"으로 메시지를 전송합니다.
    public func sendScrapMemo(requestUrl: String, templateId: Int64? = nil, templateArgs: [String:String]? = nil) -> Completable {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.scrapMemo), parameters: ["request_url":requestUrl,"template_id":templateId, "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .do (
                onNext: { _ in
                    SdkLog.i("completable:\n success\n\n" )
                }
            )
            .ignoreElements()
    }
    
    
    // MARK: Friends
    
    /// 카카오톡 친구 목록을 조회합니다.
    /// - seealso: `Friends`
    public func friends(offset: Int? = nil,
                        limit: Int? = nil,
                        order: Order? = nil) -> Single<Friends<Friend>> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.friends), parameters: ["offset": offset,
                                                                  "limit": limit,
                                                                  "order": order?.rawValue].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    
    // MARK: Message
    
    /// 기본 템플릿을 사용하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다.
    /// - seealso: [Template](../../KakaoSDKTemplate/Protocols/Templatable.html) <br> `MessageSendResult`
    public func sendDefaultMessage(templatable:Templatable, receiverUuids:[String]) -> Single<MessageSendResult> {
        return AUTH.rx.responseData(.post,
                                 Urls.compose(path:Paths.defaultMessage),
                                 parameters: ["template_object":templatable.toJsonObject()?.toJsonString(), "receiver_uuids":receiverUuids.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
//    public func sendDefaultMessage(templateObject:[String:Any], receiverUuids:[String]) -> Single<MessageSendResult> {
//        return self.responseData(.post, Urls.defaultMessage, parameters: ["template_object":templateObject.toJsonString(), "receiver_uuids":receiverUuids.toJsonString()].filterNil())
//            .compose(composeTransformerCheckApiErrorForKApi)
//            .map({ (response, data) -> MessageSendResult in
//                return try SdkJSONDecoder.custom.decode(MessageSendResult.self, from: data)
//            })
//            .asSingle()
//    }
    
    /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 사용하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/latest/ko/message/ios#create-message 을 참고하시기 바랍니다.
    /// - seealso: `MessageSendResult`
    public func sendCustomMessage(templateId: Int64, templateArgs:[String:String]? = nil, receiverUuids:[String]) -> Single<MessageSendResult> {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.customMessage), parameters: ["receiver_uuids":receiverUuids.toJsonString(), "template_id":templateId, "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 지정된 URL을 스크랩하여, 조회한 친구를 대상으로 카카오톡으로 메시지를 전송합니다. 스크랩 커스텀 템플릿 가이드(https://developers.kakao.com/docs/latest/ko/message/ios#send-kakaotalk-msg) 를  참고하여 템플릿을 직접 만들고 스크랩 메시지 전송에 이용할 수도 있습니다.
    /// - seealso: `MessageSendResult`
    public func sendScrapMessage(requestUrl: String, templateId: Int64? = nil, templateArgs:[String:String]? = nil, receiverUuids:[String]) -> Single<MessageSendResult> {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.scrapMessage),
                                        parameters: ["receiver_uuids":receiverUuids.toJsonString(), "request_url": requestUrl, "template_id":templateId, "template_args":templateArgs?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    
    // MARK: Kakaotalk Channel
    
    /// 사용자가 특정 카카오톡 채널을 추가했는지 확인합니다.
    /// - seealso: `Channel`
    public func channels(publicIds: [String]? = nil) -> Single<Channels> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.channels),
                                    parameters: ["channel_public_ids":publicIds?.toJsonString()].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
}
