//
//  WebViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/21.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit
import WebKit

final class WebViewController: UIViewController {

  // MARK: - Properties
  private let bookmark: Bookmark
  private var cancellable: Set<AnyCancellable> = []

  private lazy var webView: WKWebView = {
    let webView: WKWebView = .init()
    webView.backgroundColor = .white
    webView.allowsBackForwardNavigationGestures = true
    webView.navigationDelegate = self
    return webView
  }()

  private let stackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.distribution = .fillEqually
    stackView.backgroundColor = .t_background()
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = .init(top: -10, left: 0, bottom: -20, right: 0)
    return stackView
  }()

  private let backButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
    button.isEnabled = false
    button.imageView?.tintColor = .lightGray
    return button
  }()

  private let forwardButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.right", withConfiguration: config), for: .normal)
    button.isEnabled = false
    button.imageView?.tintColor = .lightGray
    return button
  }()

  private let reloadButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "arrow.clockwise", withConfiguration: config), for: .normal)
    button.imageView?.tintColor = .black
    return button
  }()

  private let shareButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: config), for: .normal)
    button.imageView?.tintColor = .black
    return button
  }()

  private lazy var activityViewController: UIActivityViewController = {
    let activityViewController: UIActivityViewController = .init(
      activityItems: [bookmark.urlString ?? ""],
      applicationActivities: nil
    )
    activityViewController.popoverPresentationController?.sourceView = view
    return activityViewController
  }()

  private let closeButton: UIButton = {
    let button: UIButton = .init()
    let config = UIImage.SymbolConfiguration(textStyle: .title3)
    button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
    button.imageView?.tintColor = .black
    return button
  }()

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

    setupViews()
    setupLayoutConstraints()
    openWebView()
    bindAction()
  }
}

extension WebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    backButton.isEnabled = webView.canGoBack
    backButton.imageView?.tintColor = webView.canGoBack ? .black : .lightGray
    forwardButton.isEnabled = webView.canGoForward
    forwardButton.imageView?.tintColor = webView.canGoForward ? .black : .lightGray
  }
}

private extension WebViewController {
  func setupViews() {
    view.backgroundColor = .white
    view.addSubview(webView)
    webView.addSubview(stackView)

    [backButton, forwardButton, reloadButton, shareButton, closeButton].forEach {
      stackView.addArrangedSubview($0)
    }
  }

  func setupLayoutConstraints() {
    webView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.08)
    }
  }

  func openWebView() {
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

  func bindAction() {
    backButton.tapPublisher
      .sink(receiveValue: { [weak self] in
        self?.webView.goBack()
      })
      .store(in: &cancellable)

    forwardButton.tapPublisher
      .sink(receiveValue: { [weak self] in
        self?.webView.goForward()
      })
      .store(in: &cancellable)

    reloadButton.tapPublisher
      .sink(receiveValue: { [weak self] in
        self?.webView.reload()
      })
      .store(in: &cancellable)

    shareButton.tapPublisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in
        guard let self = self else {
          return
        }
        self.present(self.activityViewController, animated: true)
      })
      .store(in: &cancellable)

    closeButton.tapPublisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] in
        self?.dismiss(animated: false)
      })
      .store(in: &cancellable)
  }
}
