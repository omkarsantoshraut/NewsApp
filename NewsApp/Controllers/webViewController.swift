//
//  webViewController.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 09/02/24.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView?
    var urlString: String

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, urlString: String) {
        self.urlString = urlString
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
    }

    private func setupView() {
        webView = WKWebView()
        webView?.allowsBackForwardNavigationGestures = true
        webView?.load(URLRequest(url: URL(string: self.urlString)!))
        webView?.translatesAutoresizingMaskIntoConstraints = false
        self.title = "NEWS"
        if let webview = webView {
            view.addSubview(webview)
            NSLayoutConstraint.activate([
                webview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                webview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                webview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                webview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
}
