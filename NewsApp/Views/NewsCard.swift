//
//  NewsCard.swift
//  NewsApp
//
//  Created by Omkar Raut on 21/12/25.
//

import Foundation
import UIKit

class NewsCard: UITableViewCell {

    // MARK: - Properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabelView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var infoContainerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, authorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [newsImageView, infoContainerStackView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.addSubview(containerStackView)
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.gray.cgColor
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var placeHolderImage: UIImage? = {
        return UIImage(systemName: "photo.fill")
    }()

    // Save images in the cache.
    private let imageCache = NSCache<NSString, UIImage>()

    private var imageViewWidthConstraint: NSLayoutConstraint?
    private var imageViewFullWidthConstraint: NSLayoutConstraint?

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Helpers

    func bindDataToView(shouldShowLargeImage: Bool,
                        title: String?,
                        description: String?,
                        urlToImage: String?,
                        author: String?,
                        sourceName: String?) {
        if shouldShowLargeImage, let imageViewWidthConstraint, let imageViewFullWidthConstraint {
            containerStackView.axis = .vertical
            NSLayoutConstraint.deactivate([imageViewWidthConstraint])
            NSLayoutConstraint.activate([imageViewFullWidthConstraint])
        }

        titleLabel.text = title
        descriptionLabel.text = description
        if let author, let sourceName {
            authorLabel.text = "- \(author) | \(sourceName)"
        }

        loadImage(from: urlToImage)
    }

    // MARK: - Private Helpers

    private func setup() {
        contentView.addSubview(containerView)

        imageViewWidthConstraint = newsImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1/3)
        imageViewFullWidthConstraint = newsImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)

        if let imageViewWidthConstraint {
            NSLayoutConstraint.activate([imageViewWidthConstraint])
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),

            newsImageView.heightAnchor.constraint(equalTo: newsImageView.widthAnchor),

            authorLabel.widthAnchor.constraint(equalTo: infoContainerStackView.widthAnchor),
        ])
    }

    private func loadImage(from urlString: String?) {
        guard let urlString, let url = URL(string: urlString) else {
            newsImageView.image = placeHolderImage
            return
        }

        // Check if cached image present.
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            newsImageView.image = cachedImage
            return
        }

        // Set placeholder image
        newsImageView.image = placeHolderImage

        // Use URLSession to fetch the image data.
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                return
            }

            guard let self, let data = data, let image = UIImage(data: data) else {
                return
            }

            // Save image into the cache
            self.imageCache.setObject(image, forKey: urlString as NSString)

            // Set the image on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.newsImageView.image = image
            }
        }

        task.resume()
    }

    // MARK: - Overriden Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        // Reset text labels
        titleLabel.text = nil
        descriptionLabel.text = nil
        authorLabel.text = nil

        // Reset image view
        newsImageView.image = nil

        // Optionally reset the image view's constraints if needed
        if let imageViewWidthConstraint = imageViewWidthConstraint {
            NSLayoutConstraint.deactivate([imageViewWidthConstraint])
        }
        if let imageViewFullWidthConstraint = imageViewFullWidthConstraint {
            NSLayoutConstraint.deactivate([imageViewFullWidthConstraint])
        }

        // Re-apply the default image width constraint for reuse
        containerStackView.axis = .horizontal
        NSLayoutConstraint.activate([imageViewWidthConstraint].compactMap { $0 })
    }
}
