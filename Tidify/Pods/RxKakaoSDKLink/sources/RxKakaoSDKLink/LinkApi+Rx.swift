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

import KakaoSDKLink
import KakaoSDKTemplate

extension LinkApi: ReactiveCompatible {}

/// `LinkApi`의 ReactiveX 확장입니다.
///
extension Reactive where Base: LinkApi {
    
    // MARK: Fields
    
    /// 템플릿 조회 API 응답을 카카오링크 URL로 변환합니다.
    /// - seealso: `LinkResult`
    public func createLinkResultComposeTransformer(targetAppKey:String? = nil) -> ComposeTransformer<(ValidationResult, [String:Any]?), LinkResult> {
        return ComposeTransformer<(ValidationResult, [String:Any]?), LinkResult> { (observable) in
            
            return observable.flatMap { (validationResult, serverCallbackArgs) -> Observable<LinkResult> in
                SdkLog.d("--------------------------------- validationResult \(validationResult)")
                
                return Observable<LinkResult>.create { (observer) in
                    let extraParameters = ["KA":Constants.kaHeader,
                                           "iosBundleId":Bundle.main.bundleIdentifier,
                                           "lcba":serverCallbackArgs?.toJsonString()
                        ].filterNil()
                    
                    let linkParameters = ["appkey" : try! KakaoSDKCommon.shared.appKey(),
                                          "target_app_key" : targetAppKey,
                                          "appver" : Constants.appVersion(),
                                          "linkver" : "4.0",
                                          "template_json" : validationResult.templateMsg.toJsonString(),
                                          "template_id" : validationResult.templateId,
                                          "template_args" : validationResult.templateArgs?.toJsonString(),
                                          "extras" : extraParameters?.toJsonString()
                        ].filterNil()
                    
                    if let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkLink, path:Paths.talkLink), parameters: linkParameters) {
                        SdkLog.d("--------------------------------url \(url)")
                        
                        if LinkApi.isExceededLimit(linkParameters: linkParameters, validationResult: validationResult, extras: extraParameters) {
                            observer.onError(SdkError(reason: .ExceedKakaoLinkSizeLimit))
                        } else {
                            observer.onNext(LinkResult(url: url, warningMsg: validationResult.warningMsg, argumentMsg: validationResult.argumentMsg))
                            observer.onCompleted()
                        }
                    }
                    else {
                        observer.onError(SdkError(reason:.BadParameter, message: "Invalid Url."))
                    }
                    return Disposables.create()
                }
            }
        }
    }
    
    // MARK: Using KakaoTalk
    
    func defaultLink(templateObjectJsonString:String?, serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.defalutLink),
                                parameters: ["link_ver":"4.0",
                                             "template_object":templateObjectJsonString,
                                             "target_app_key":try! KakaoSDKCommon.shared.appKey()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDKCommon.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: `Template` <br> `LinkResult`
    public func defaultLink(templatable: Templatable, serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return self.defaultLink(templateObjectJsonString: templatable.toJsonObject()?.toJsonString(), serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 기본 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: `LinkResult`
    public func defaultLink(templateObject:[String:Any], serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return self.defaultLink(templateObjectJsonString: templateObject.toJsonString(), serverCallbackArgs:serverCallbackArgs)
    }
    
    /// 지정된 URL을 스크랩하여 만들어진 템플릿을 카카오톡으로 공유합니다.
    /// - seealso: `LinkResult`
    public func scrapLink(requestUrl:String, templateId:Int64? = nil, templateArgs:[String:String]? = nil, serverCallbackArgs:[String:String]? = nil ) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.scrapLink),
                                parameters: ["link_ver":"4.0",
                                             "request_url":requestUrl,
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString(),
                                             "target_app_key":try! KakaoSDKCommon.shared.appKey()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDKCommon.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오 디벨로퍼스에서 생성한 메시지 템플릿을 카카오톡으로 공유합니다. 템플릿을 생성하는 방법은 https://developers.kakao.com/docs/latest/ko/message/ios#create-message 을 참고하시기 바랍니다.
    /// - seealso: `LinkResult`
    public func customLink(templateId:Int64, templateArgs:[String:String]? = nil, serverCallbackArgs:[String:String]? = nil) -> Single<LinkResult> {
        return API.rx.responseData(.post,
                                Urls.compose(path:Paths.validateLink),
                                parameters: ["link_ver":"4.0",
                                             "template_id":templateId,
                                             "template_args":templateArgs?.toJsonString(),
                                             "target_app_key":try! KakaoSDKCommon.shared.appKey()]
                                    .filterNil(),
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDKCommon.shared.appKey())"],
                                sessionType: .Api
            )
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (ValidationResult, [String:Any]?) in
                return (try SdkJSONDecoder.default.decode(ValidationResult.self, from: data), serverCallbackArgs)
            })
            .compose(createLinkResultComposeTransformer())
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded model:\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
 
    // MARK: Image Upload
    
    /// 카카오링크 컨텐츠 이미지로 활용하기 위해 로컬 이미지를 카카오 이미지 서버로 업로드 합니다.
    public func imageUpload(image: UIImage, secureResource: Bool = true) -> Single<ImageUploadResult> {
        return API.rx.upload(.post, Urls.compose(path:Paths.imageUploadLink),
                          images: [image],
                          parameters: ["secure_resource": secureResource],
                          headers: ["Authorization":"KakaoAK \(try! KakaoSDKCommon.shared.appKey())"],
                          sessionType: .Api)
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 카카오링크 컨텐츠 이미지로 활용하기 위해 원격 이미지를 카카오 이미지 서버로 스크랩 합니다.
    public func imageScrap(imageUrl: URL, secureResource: Bool = true) -> Single<ImageUploadResult> {
        return API.rx.responseData(.post, Urls.compose(path:Paths.imageScrapLink),
                                parameters: ["image_url": imageUrl.absoluteString, "secure_resource": secureResource],
                                headers: ["Authorization":"KakaoAK \(try! KakaoSDKCommon.shared.appKey())"],
                                sessionType: .Api)
            .compose(API.rx.checkKApiErrorComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
}
