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

import UIKit
import RxSwift
import RxCocoa
import SafariServices
import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth

import RxKakaoSDKCommon

let authController = AuthController.shared

extension AuthController: ReactiveCompatible {}

extension Reactive where Base: AuthController {

//extension AuthController {
        
    // MARK: Login with KakaoTalk
    
    /// :nodoc:
    public func authorizeWithTalk(channelPublicIds: [String]? = nil,
                                  serviceTerms: [String]? = nil) -> Observable<OAuthToken> {
        return Observable<String>.create { observer in
            authController.authorizeWithTalkCompletionHandler = { (callbackUrl) in
                let parseResult = callbackUrl.oauthResult()
                if let code = parseResult.code {
                    observer.onNext(code)
                } else {
                    let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                    SdkLog.e("Failed to parse redirect URI.")
                    observer.onError(error)
                }
            }
            
            let parameters = authController.makeParametersForTalk(channelPublicIds: channelPublicIds, serviceTerms: serviceTerms)

            guard let url = SdkUtils.makeUrlWithParameters(Urls.compose(.TalkAuth, path:Paths.authTalk), parameters: parameters) else {
                SdkLog.e("Bad Parameter.")
                observer.onError(SdkError(reason: .BadParameter))
                return Disposables.create()
            }
            
            UIApplication.shared.open(url, options: [:]) { (result) in
                if (result) {
                    SdkLog.d("카카오톡 실행: \(url.absoluteString)")
                }
                else {
                    SdkLog.e("카카오톡 실행 취소")
                    observer.onError(SdkError(reason: .Cancelled, message: "The KakaoTalk authentication has been canceled by user."))
                    return
                }
            }
            
            return Disposables.create()
        }
        .flatMap { code in
            AuthApi.shared.rx.token(code: code, codeVerifier: authController.codeVerifier)
        }
    }
    
    /// **카카오톡 간편로그인** 등 외부로부터 리다이렉트 된 코드요청 결과를 처리합니다.
    /// AppDelegate의 openURL 메소드 내에 다음과 같이 구현해야 합니다.
    ///
    /// ```
    /// func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    ///     if (AuthController.isKakaoTalkLoginUrl(url)) {
    ///         if AuthController.rx.handleOpenUrl(url: url, options: options) {
    ///             return true
    ///         }
    ///     }
    ///
    ///     // 서비스의 나머지 URL 핸들링 처리
    /// }
    ///
    public static func handleOpenUrl(url:URL,  options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthController.isValidRedirectUri(url)) {
            if let authorizeWithTalkCompletionHandler = authController.authorizeWithTalkCompletionHandler {
                authorizeWithTalkCompletionHandler(url)
            }
        }
        return false
    }
    
    // MARK: Login with Web Cookie
    
    ///:nodoc: 카카오 계정 페이지에서 로그인을 하기 위한 지원스펙 입니다.
    public func authorizeWithAuthenticationSession(accountParameters: [String:String]? = nil) -> Observable<OAuthToken>  {
        return self.authorizeWithAuthenticationSession(agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: nil,
                                                       serviceTerms:nil,
                                                       accountParameters: accountParameters)
    }
    
    /// :nodoc:
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil) -> Observable<OAuthToken> {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: nil,
                                                       serviceTerms:nil)
    }
    
    /// :nodoc: 카카오싱크 전용입니다. 자세한 내용은 카카오싱크 전용 개발가이드를 참고하시기 바랍니다.
    public func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                                   channelPublicIds: [String]? = nil,
                                                   serviceTerms: [String]? = nil) -> Observable<OAuthToken> {
        return self.authorizeWithAuthenticationSession(prompts: prompts,
                                                       agtToken: nil,
                                                       scopes: nil,
                                                       channelPublicIds: channelPublicIds,
                                                       serviceTerms:serviceTerms)
    }
    
    
    // MARK: New Agreement
    
    /// :nodoc:
    public func authorizeWithAuthenticationSession(scopes:[String]) -> Observable<OAuthToken> {
        return AuthApi.shared.rx.agt().asObservable().flatMap({ agtToken -> Observable<OAuthToken> in
            return self.authorizeWithAuthenticationSession(agtToken: agtToken, scopes: scopes)
        })
    }
  
    /// :nodoc:
    func authorizeWithAuthenticationSession(prompts : [Prompt]? = nil,
                                            agtToken: String? = nil,
                                            scopes:[String]? = nil,
                                            channelPublicIds: [String]? = nil,
                                            serviceTerms: [String]? = nil,
                                            accountParameters: [String:String]? = nil) -> Observable<OAuthToken> {
        return Observable<String>.create { observer in
            let authenticationSessionCompletionHandler : (URL?, Error?) -> Void = {
                (callbackUrl:URL?, error:Error?) in
                
                guard let callbackUrl = callbackUrl else {
                    if #available(iOS 12.0, *), let error = error as? ASWebAuthenticationSessionError {
                        if error.code == ASWebAuthenticationSessionError.canceledLogin {
                            SdkLog.e("The authentication session has been canceled by user.")
                            observer.onError(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                        } else {
                            SdkLog.e("An error occurred on executing authentication session.\n reason: \(error)")
                            observer.onError(SdkError(reason: .Unknown, message: "An error occurred on executing authentication session."))
                        }
                    } else if let error = error as? SFAuthenticationError, error.code == SFAuthenticationError.canceledLogin {
                        SdkLog.e("The authentication session has been canceled by user.")
                        observer.onError(SdkError(reason: .Cancelled, message: "The authentication session has been canceled by user."))
                    } else {
                        SdkLog.e("An unknown authentication session error occurred.")
                        observer.onError(SdkError(reason: .Unknown, message: "An unknown authentication session error occurred."))
                    }
                    return
                }
                print("callbackUrl: \(callbackUrl)")
                let parseResult = callbackUrl.oauthResult()
                if let code = parseResult.code {
                    SdkLog.i("code:\n \(String(describing: code))\n\n" )
                    observer.onNext(code)
                } else {
                    let error = parseResult.error ?? SdkError(reason: .Unknown, message: "Failed to parse redirect URI.")
                    SdkLog.e("Failed to parse redirect URI.")
                    observer.onError(error)
                }
            }
            
            var parameters = authController.makeParameters(prompts: prompts,
                                                           agtToken: agtToken,
                                                           scopes: scopes,
                                                           channelPublicIds: channelPublicIds,
                                                           serviceTerms: serviceTerms)
            
            var url: URL? = nil
            if let accountParameters = accountParameters, !accountParameters.isEmpty {
                for (key, value) in accountParameters {
                    parameters[key] = value
                }
                
                url = SdkUtils.makeUrlWithParameters(Urls.compose(.Auth, path:Paths.kakaoAccountsLogin), parameters:parameters)
            }
            else {
                url = SdkUtils.makeUrlWithParameters(Urls.compose(.Kauth, path:Paths.authAuthorize), parameters:parameters)
            }            
            
            if let url = url {
                SdkLog.d("\n===================================================================================================")
                SdkLog.d("request: \n url:\(url)\n parameters: \(parameters) \n")
                
                if #available(iOS 12.0, *) {
                    let authenticationSession = ASWebAuthenticationSession(url: url,
                                                                           callbackURLScheme: (try! KakaoSDKCommon.shared.scheme()),
                                                                           completionHandler:authenticationSessionCompletionHandler)
                    if #available(iOS 13.0, *) {
                        authenticationSession.presentationContextProvider = authController.presentationContextProvider as? ASWebAuthenticationPresentationContextProviding
                        if agtToken != nil {
                            authenticationSession.prefersEphemeralWebBrowserSession = true
                        }
                    }
                    authenticationSession.start()
                    authController.authenticationSession = authenticationSession
                }
                else {
                    authController.authenticationSession = SFAuthenticationSession(url: url,
                                                                                   callbackURLScheme: (try! KakaoSDKCommon.shared.scheme()),
                                                                                   completionHandler:authenticationSessionCompletionHandler)
                    (authController.authenticationSession as? SFAuthenticationSession)?.start()
                }
            }
            return Disposables.create()
        }
        .flatMap { code in
            AuthApi.shared.rx.token(code: code, codeVerifier: authController.codeVerifier)
        }
        
    }
}
