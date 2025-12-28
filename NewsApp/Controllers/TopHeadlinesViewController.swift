//
//  TopHeadlinesViewController.swift
//  NewsApp
//
//  Created by Omkar Raut on 21/12/25.
//

import Foundation
import UIKit

/**
 The view controller for the top headlines screen.
 */
class TopHeadlinesViewController: UIViewController {

    // MARK: - Properties

    private var topNews: NewsModel?

    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private lazy var errorScreenView: ErrorScreenView = {
        let view = ErrorScreenView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var alertViewController: UIAlertController = {
        let alert = UIAlertController(title: "ERROR!", message: "Url is not present.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)
        fetchTopHeadlines()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Top Headlines"

        // Add and setup table view.
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        view.addSubview(errorScreenView)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NewsCard.self, forCellReuseIdentifier: "TopHeadlinesCardCell")
        tableView.isHidden = true

        loadingIndicator.startAnimating()
        errorScreenView.delegate = self
        errorScreenView.isHidden = true

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            loadingIndicator.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            errorScreenView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorScreenView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorScreenView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorScreenView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

extension TopHeadlinesViewController {
    private func fetchTopHeadlines() {
        guard let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=3cc65cce7b9f47778f7851b1d63f8589") else {
            loadingIndicator.stopAnimating()
            errorScreenView.isHidden = false
            return
        }

        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { [weak self] (data, response, error) in
            guard error == nil, let data, let self else {
                DispatchQueue.main.async { [weak self] in
                    self?.loadingIndicator.stopAnimating()
                    self?.errorScreenView.isHidden = false
                }
                return
            }

            self.extractDataIntoModel(data: data)
        })

        task.resume()
    }

    private func extractDataIntoModel(data: Data) {
        do {
            // assign the data..
            self.topNews = try JSONDecoder().decode(NewsModel.self, from: data)
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
            }
        } catch {
            loadingIndicator.stopAnimating()
            errorScreenView.isHidden = false
        }
    }
}

// MARK: - ErrorScreenViewProtocol

extension TopHeadlinesViewController: ErrorScreenViewProtocol {
    func refreshButtonTapped() {
        loadingIndicator.startAnimating()
        errorScreenView.isHidden = true
        fetchTopHeadlines()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topNews?.articles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let topNews,
              let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeadlinesCardCell", for: indexPath) as? NewsCard else {
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        let article = topNews.articles[indexPath.row]
        cell.bindDataToView(
            shouldShowLargeImage: indexPath.row == 0,
            title: article.title,
            description: article.description,
            urlToImage: article.urlToImage,
            author: article.author,
            sourceName: article.source.name)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let url = topNews?.articles[indexPath.row].url {
            let webViewController = WebViewController(nibName: nil, bundle: nil, urlString: url)
            self.navigationController?.pushViewController(webViewController, animated: true)
        } else {
            // show error alert.
            present(alertViewController, animated: true)
        }
    }
}
