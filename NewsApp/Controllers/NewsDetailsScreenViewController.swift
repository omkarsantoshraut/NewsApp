//
//  NewsDetailsScreenViewController.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 08/02/24.
//

import Foundation
import UIKit
import WebKit

class NewsDetailsScreenViewController: UIViewController {

    private var keyword: String
    private var newsModel: NewsModel?

    private let tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .grouped)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()

    // MARK: - Initializers

    public init(keyWord: String) {
        self.keyword = keyWord

        super.init(nibName: nil, bundle: nil)

        Task {
            do {
                self.newsModel = try await fetchLatestNews(keyword: keyWord)
                self.tableView.reloadData()
            } catch {
                print("#### Error")
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(NewsDetailsScreenView.self, forCellReuseIdentifier: "tableViewCell")

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    /**
     Fetch the latest news with spesific keyword.
     @param  keyword    keyword to fetch news of that keyword.
     @return    an instance of NewsModel.
     */
    private func fetchLatestNews(keyword: String) async throws -> NewsModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: Date().dayBefore)
        let urlString = "https://newsapi.org/v2/everything?q=\(keyword)&from=\(date)&sortBy=publishedAt&apiKey=3cc65cce7b9f47778f7851b1d63f8589"

        let request = URLRequest(url: URL(string: urlString)!)
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        return try JSONDecoder().decode(NewsModel.self, from: data)
    }
}

extension NewsDetailsScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel?.totalResults ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! NewsDetailsScreenView
        tableViewCell.setData(article: newsModel?.articles[indexPath.row])
        return tableViewCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WebViewController(nibName: nil, bundle: nil, urlString: (newsModel?.articles[indexPath.row].url)!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Date {
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }
}
