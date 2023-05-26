//
//  DetailWebViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit
import WebKit

final class DetailWebViewController: UIViewController {

  // MARK: - Properties
  private let webView: WKWebView = .init()

  private let bookmark: Bookmark

  // MARK: - Initializer
  init(bookmark: Bookmark) {
    self.bookmark = bookmark

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    navigationController?.navigationBar.topItem?.title = ""

    var urlString: String = bookmark.urlString ?? ""
    if !(urlString.contains("http://") || urlString.contains("https://")) {
      urlString = "https://" + urlString
    }

    guard let url = URL(string: urlString) else {
      return
    }

    let urlRequest: URLRequest = .init(url: url)
    webView.load(urlRequest)
  }
}

private extension DetailWebViewController {
  func setupUI() {
    view.backgroundColor = .white

    view.addSubview(webView)

    webView.do {
      $0.allowsBackForwardNavigationGestures = true
      $0.uiDelegate = self
      $0.navigationDelegate = self
      $0.backgroundColor = .white
    }

    webView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension DetailWebViewController: WKUIDelegate {}
extension DetailWebViewController: WKNavigationDelegate {}
