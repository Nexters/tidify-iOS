//
//  AuthViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import UIKit
import WebKit

final class AuthViewController: UIViewController {

  // MARK: - Properties
  private let webView: WKWebView = .init()
  private let url: URL
  private let coordinator: SignInCoordinator?

  // MARK: - Constructor
  init(url: URL, coordinator: SignInCoordinator) {
    self.url = url
    self.coordinator = coordinator

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupView()
  }
}

private extension AuthViewController {
  func setupUI() {
    view.backgroundColor = .white
    view.addSubview(webView)

    webView.do {
      $0.allowsBackForwardNavigationGestures = true
      $0.backgroundColor = .black
      $0.customUserAgent = AppProperties.userAgent
    }

    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupView() {
    cleanCache()
    
    let urlRequest: URLRequest = .init(url: url)
    webView.configuration.websiteDataStore.httpCookieStore.add(self)
    webView.load(urlRequest)
  }
  
  func cleanCache() {
    HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
    
    WKWebsiteDataStore.default().fetchDataRecords(
      ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()
    ) { records in
      records.forEach { record in
        WKWebsiteDataStore.default().removeData(
          ofTypes: record.dataTypes,
          for: [record],
          completionHandler: {}
        )
      }
    }
  }
}

extension AuthViewController: WKHTTPCookieStoreObserver {
  func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
    cookieStore.getAllCookies({ [weak self] cookies in
      let tokenCookies = cookies.filter { $0.name == "access-token" || $0.name == "refresh-token" }
      guard !tokenCookies.isEmpty else { return }
      
      var accessToken: String = .init()
      var refreshToken: String = .init()
      
      tokenCookies.forEach {
        switch $0.name {
        case "access-token": accessToken = $0.value
        case "refresh-token": refreshToken = $0.value
        default: return
        }
      }
      
      let userToken: UserToken = .init(accessToken: accessToken, refreshToken: refreshToken)
      AppProperties.userToken = userToken
      
      guard let self = self else { return }
      self.webView.configuration.websiteDataStore.httpCookieStore.remove(self)
      self.coordinator?.popAuthView()
    })
  }
}
