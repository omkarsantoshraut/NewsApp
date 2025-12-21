//
//  NewsDetailsScreenView.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 08/02/24.
//

import Foundation
import UIKit

class NewsDetailsScreenView: UITableViewCell {

    private static let seeMoreButtonTitleText = "See More"

    public lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 24)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var publishedTimeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public lazy var customImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    public lazy var authorlabel: UILabel = {
       let label = UILabel()
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 14)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var vStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [titleLabel, publishedTimeLabel, customImageView, descriptionLabel, authorlabel])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setView()
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(article: article?) {
        titleLabel.text = article?.title
        descriptionLabel.text = article?.description
        DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: article?.urlToImage ?? "https://images.unsplash.com/photo-1536941675050-58c5c58963eb?q=80&w=2848&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D")!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.customImageView.image = image
                            }
                        }
                    }
                }
        publishedTimeLabel.text = "\(article?.source.name ?? "") / \(article?.publishedAt ?? "Today")"
        authorlabel.text = "- \(article?.author ?? "")"
    }

    private func setView() {
        self.backgroundColor = .secondarySystemBackground
        self.addSubview(vStack)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            vStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            vStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            vStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: publishedTimeLabel.topAnchor, constant: -10),
            publishedTimeLabel.bottomAnchor.constraint(equalTo: customImageView.topAnchor, constant: -20),
            customImageView.heightAnchor.constraint(equalToConstant: 200),
            customImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: authorlabel.topAnchor, constant: -20),
            authorlabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
