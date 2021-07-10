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

import KakaoSDKStory

extension StoryApi: ReactiveCompatible {}

/// `StoryApi`의 ReactiveX 확장입니다.
///
/// 아래는 story/profile을 호출하는 간단한 예제입니다.
///
///     StoryApi.shared.rx.profile()
///        .retryWhen(Auth.shared.rx.incrementalAuthorizationRequired())
///        .subscribe(onSuccess:{ (profile) in
///            print(profile)
///        }, onError: { (error) in
///            print(error)
///        })
///        .disposed(by: <#Your DisposeBag#>)
extension Reactive where Base: StoryApi {
    
    // MARK: Fields
    
    
    // MARK: API Methods

    /// 사용자가 카카오스토리 사용자인지 아닌지를 판별합니다.
    public func isStoryUser() -> Single<Bool> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.isStoryUser))
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> Bool in
                if let json = (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String: Any] {
                    if let isStoryUser = json["isStoryUser"] as? Bool {
                        return isStoryUser
                    }
                    else {
                        return false
                    }
                }
                else {
                    return false
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded :\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 로그인된 사용자의 카카오스토리 프로필 정보를 얻을 수 있습니다.
    /// - seealso: `StoryProfile`
    public func profile(secureResource: Bool = true) -> Single<StoryProfile> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.storyProfile),
                                 parameters: ["secure_resource":secureResource].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 카카오스토리의 특정 내스토리 정보를 얻을 수 있습니다. comments, likes등의 상세정보도 포함됩니다.
    /// - seealso: `Story`
    public func story(id:String) -> Single<Story> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.myStory),
                                 parameters: ["id":id].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 카카오스토리의 여러 개의 내스토리 정보들을 얻을 수 있습니다. 단, comments, likes등의 상세정보는 없으며 이는 내스토리 정보 요청 `story(id:)`을 통해 얻을 수 있습니다.
    /// - seealso: `Story`
    public func stories(lastId:String? = nil) -> Single<[Story]?> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.myStories),
                                 parameters: ["last_id":lastId].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.customIso8601Date, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 포스팅하고자 하는 URL을 스크랩하여 링크 정보를 생성합니다.
    /// - seealso: `LinkInfo`
    public func linkInfo(url: URL) -> Single<LinkInfo> {
        return AUTH.rx.responseData(.get, Urls.compose(path:Paths.storyLinkInfo),
                                 parameters: ["url":url].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> (SdkJSONDecoder, HTTPURLResponse, Data) in
                return (SdkJSONDecoder.custom, response, data)
            })
            .compose(API.rx.decodeDataComposeTransformer())
            .asSingle()
    }
    
    /// 카카오스토리에 글(노트)을 포스팅합니다.
    public func postNote(content:String,
                         permission:Story.Permission = .Public,
                         enableShare:Bool? = false,
                         androidExecParam: [String: String]? = nil,
                         iosExecParam: [String: String]? = nil,
                         androidMarketParam: [String: String]? = nil,
                         iosMarketParam: [String: String]? = nil) -> Single<String> {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.postNote),
                                 parameters: ["content":content,
                                              "permission":permission.parameterValue,
                                              "enable_share":enableShare,
                                              "android_exec_param":androidExecParam?.queryParameters,
                                              "ios_exec_param":iosExecParam?.queryParameters,
                                              "android_market_param":androidMarketParam?.queryParameters,
                                              "ios_market_param":iosMarketParam?.queryParameters].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> String in
                if 200 ..< 300 ~= response.statusCode {
                    if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any], let postId = json["id"] as? String {
                        return postId
                    } else {
                        throw SdkError(reason: .Unknown, message: "No post identifier in the response body. But posting is successful.")
                    }
                } else {
                    throw SdkError(response: response, data: data, type: .KApi) ?? SdkError(reason: .Unknown, message: "Your posting failed.")
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded :\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오스토리에 링크(스크랩 정보)를 포스팅합니다.
    ///
    /// 먼저 포스팅하고자 하는 URL로 스크랩 API를 호출한 후 반환된 링크 정보를 파라미터로 전달하여 포스팅 해야 합니다.
    /// - seealso: `linkInfo(url:)` <br>`LinkInfo`
    public func postLink(content:String? = nil,
                         linkInfo:LinkInfo,
                         permission:Story.Permission = .Public,
                         enableShare:Bool? = false,
                         androidExecParam: [String: String]? = nil,
                         iosExecParam: [String: String]? = nil,
                         androidMarketParam: [String: String]? = nil,
                         iosMarketParam: [String: String]? = nil) -> Single<String> {
        
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.postLink),
                                 parameters: ["content":content,
                                              "link_info":SdkUtils.toJsonString(linkInfo),
                                              "permission":permission.parameterValue,
                                              "enable_share":enableShare,
                                              "android_exec_param":androidExecParam?.queryParameters,
                                              "ios_exec_param":iosExecParam?.queryParameters,
                                              "android_market_param":androidMarketParam?.queryParameters,
                                              "ios_market_param":iosMarketParam?.queryParameters].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> String in
                if 200 ..< 300 ~= response.statusCode {
                    if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any], let postId = json["id"] as? String {
                        return postId
                    } else {
                        throw SdkError(reason: .Unknown, message: "No post identifier in the response body. But posting is successful.")
                    }
                } else {
                    throw SdkError(response: response, data: data, type: .KApi) ?? SdkError(reason: .Unknown, message: "Your posting failed.")
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded :\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오스토리에 사진(들)을 포스팅합니다.
    public func postPhoto(content:String? = nil,
                          imagePaths:[String],
                          permission:Story.Permission = .Public,
                          enableShare:Bool? = false,
                          androidExecParam: [String: String]? = nil,
                          iosExecParam: [String: String]? = nil,
                          androidMarketParam: [String: String]? = nil,
                          iosMarketParam: [String: String]? = nil) -> Single<String> {
        return AUTH.rx.responseData(.post, Urls.compose(path:Paths.postPhoto),
                                 parameters: ["content":content,
                                              "image_url_list":imagePaths.toJsonString(),
                                              "permission":permission.parameterValue,
                                              "enable_share":enableShare,
                                              "android_exec_param":androidExecParam?.queryParameters,
                                              "ios_exec_param":iosExecParam?.queryParameters,
                                              "android_market_param":androidMarketParam?.queryParameters,
                                              "ios_market_param":iosMarketParam?.queryParameters].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> String in
                if 200 ..< 300 ~= response.statusCode {
                    if let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any], let postId = json["id"] as? String {
                        return postId
                    } else {
                        throw SdkError(reason: .Unknown, message: "No post identifier in the response body. But posting is successful.")
                    }
                } else {
                    throw SdkError(response: response, data: data, type: .KApi) ?? SdkError(reason: .Unknown, message: "Your posting failed.")
                }
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded :\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 로컬 이미지 파일 여러장을 카카오스토리에 업로드합니다. (JPEG 형식)
    public func upload(_ images: [UIImage?]) -> Single<[String]?> {
        return AUTH.rx.upload(.post, Urls.compose(path:Paths.uploadMulti), images: images)
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .map({ (response, data) -> [String]? in
                return (try? JSONSerialization.jsonObject(with:data, options:[])) as? [String]
            })
            .do (
                onNext: { ( decoded ) in
                    SdkLog.i("decoded :\n \(String(describing: decoded))\n\n" )
                }
            )
            .asSingle()
    }
    
    /// 카카오스토리의 특정 내스토리 정보를 지울 수 있습니다.
    public func delete(_ id: String) -> Completable {
        return AUTH.rx.responseData(.delete, Urls.compose(path:Paths.deleteMyStory),
                                 parameters: ["id":id].filterNil())
            .compose(AUTH.rx.checkErrorAndRetryComposeTransformer())
            .do (
                onNext: { _ in
                    SdkLog.i("completable:\n success\n\n" )
                }
            )
            .ignoreElements()
    }
}


