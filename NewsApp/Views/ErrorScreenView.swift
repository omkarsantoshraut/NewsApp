//
//  ErrorScreenView.swift
//  NewsApp
//
//  Created by Omkar Raut on 27/12/25.
//

import Foundation
import UIKit

protocol ErrorScreenViewProtocol {
    func refreshButtonTapped()
}

class ErrorScreenView: UIView {

    // MARK: - Properties

    private lazy var title: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Something went wrong."
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var refreshButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Refresh", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.titleLabel?.textColor = .blue
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(tappedRefreshButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.addSubview(title)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }()

    private lazy var refreshButtonContainerView: UIView = {
        let view = UIView()
        view.addSubview(refreshButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleContainerView, refreshButtonContainerView])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var delegate: ErrorScreenViewProtocol?

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Helpers

    private func setup() {
        addSubview(containerStackView)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            refreshButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 1/2)
        ])
    }

    @objc
    private func tappedRefreshButton() {
        delegate?.refreshButtonTapped()
    }
}
