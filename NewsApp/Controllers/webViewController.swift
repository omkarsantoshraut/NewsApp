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

    // MARK: - Properties

    var webView: WKWebView?
    var urlString: String

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.backgroundColor = UIColor(white: 0, alpha: 0.4)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var errorScreenView: ErrorScreenView = {
        let view = ErrorScreenView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Initializers

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, urlString: String) {
        self.urlString = urlString
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        
    }

    // MARK: - Private Helpers

    private func setupView() {
        webView = WKWebView()
        webView?.allowsBackForwardNavigationGestures = true
        webView?.load(URLRequest(url: URL(string: self.urlString)!))
        webView?.translatesAutoresizingMaskIntoConstraints = false
        webView?.navigationDelegate = self
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

        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(errorScreenView)
        errorScreenView.delegate = self
        errorScreenView.isHidden = true
        NSLayoutConstraint.activate([
            errorScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - Web View Methods

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loadingIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        errorScreenView.isHidden = false
        loadingIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        errorScreenView.isHidden = false
        loadingIndicator.stopAnimating()
    }
}

// MARK: - ErrorScreenViewProtocol

extension WebViewController: ErrorScreenViewProtocol {
    func refreshButtonTapped() {
        loadingIndicator.startAnimating()
        errorScreenView.isHidden = true
        webView?.load(URLRequest(url: URL(string: self.urlString)!))
    }
}
