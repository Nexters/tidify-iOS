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
  private weak var coordinator: SignInCoordinator?

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
      $0.uiDelegate = self
      $0.navigationDelegate = self
      $0.backgroundColor = .black
    }

    webView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func setupView() {
    let urlRequest: URLRequest = .init(url: url)
    webView.load(urlRequest)
  }
}

extension AuthViewController: WKUIDelegate {}
extension AuthViewController: WKNavigationDelegate {}
