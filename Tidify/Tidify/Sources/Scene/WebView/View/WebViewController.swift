//
//  WebViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import WebKit

class WebViewController: UIViewController {
    weak var coordinator: Coordinator?

    private weak var webView: WKWebView!

    private let viewModel: WebViewViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: WebViewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        let url = URL(string: "https://www.apple.com")!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func setupViews() {
        let webView = WKWebView().then {
            $0.allowsBackForwardNavigationGestures = true
            $0.uiDelegate = self
            $0.navigationDelegate = self
            $0.configuration.preferences.javaScriptEnabled = true
            view.addSubview($0)
        }
        self.webView = webView
    }

    func setupLayoutConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension WebViewController: WKUIDelegate {

}

extension WebViewController: WKNavigationDelegate {

}
