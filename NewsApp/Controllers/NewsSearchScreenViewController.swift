//
//  NewsSearchScreenViewController.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 07/02/24.
//

import UIKit

class NewsSearchScreenViewController: UIViewController, NewsSearchProtocol {

    let newsSearchScreenView: NewsSearchScreenView = {
        let newsSearchView = NewsSearchScreenView(frame: .zero)
        newsSearchView.translatesAutoresizingMaskIntoConstraints = false
        return newsSearchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        newsSearchScreenView.delegate = self
        setView()
        setConstraints()
    }

    private func setView() {
        view.addSubview(newsSearchScreenView)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsSearchScreenView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            newsSearchScreenView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            newsSearchScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newsSearchScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    

    // MARK: - NewsSearchProtocol

    func searchButtonTapped(withText: String) {
        let vc = NewsDetailsScreenViewController(keyWord: withText)
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

