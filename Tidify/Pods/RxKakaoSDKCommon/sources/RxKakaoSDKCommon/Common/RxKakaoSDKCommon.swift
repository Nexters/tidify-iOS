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
import KakaoSDKCommon

/// ReactiveX Kakao SDK 공통의 환경변수 설정을 위한 클래스입니다.
///
/// 싱글톤으로 제공되는 인스턴스를 사용해야 하며 다음과 같이 초기화할 수 있습니다.
///
///     // AppDelegate.swift
///     func application(_ application: UIApplication,
///                      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
///
///         RxKakaoSDKCommon.initSDK(appKey: "<#Your App Key#>")
///
///         return true
///     }
/// - important: SDK 초기화가 수행되지 않으면 SDK 내 모든 기능을 사용할 수 없습니다. 반드시 가장 먼저 실행되어야 합니다.
final public class RxKakaoSDKCommon {
    
    // MARK: Fields
    
    /// ReactiveX Kakao SDK 초기화를 수행합니다.
    /// - parameters:
    ///   - appKey: [카카오 디벨로퍼스](https://developers.kakao.com)에서 발급 받은 NATIVE_APP_KEY
    ///   - customScheme: 로그인 시 인증코드를 발급 받을 URI. 내 앱의 커스텀 스킴에 로그인 요청임을 구분할 수 있는 host 및 path를 덧붙여 사용합니다. ex) myappscheme://oauth
    ///   - loggingEnable: SDK에서 디버그 로깅를 사용 여부
    
    public static func initSDK(appKey: String, customScheme: String? = nil, loggingEnable: Bool = false, hosts: Hosts? = nil) {
        KakaoSDKCommon.shared.initialize(appKey: appKey, customScheme: customScheme, loggingEnable: loggingEnable, hosts: hosts, sdkType:.RxSwift)
    }
}
