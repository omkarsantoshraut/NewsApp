//
//  NewsSearchScreenView.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 07/02/24.
//

import Foundation
import UIKit

protocol NewsSearchProtocol {
    func searchButtonTapped(withText: String)
}

class NewsSearchScreenView: UIView {

    var delegate: NewsSearchProtocol?

    // MARK: - Private constants

    private static let textFieldPlaceholderText = "Please enter any topic to search."
    private static let searchButtonTitleText = "Search"

    // MARK: - Private properties

    private let textField: UITextField = {
        let textField = UITextField()
         textField.textColor = .black
         textField.attributedPlaceholder = NSAttributedString(string: NewsSearchScreenView.textFieldPlaceholderText)
         textField.clearButtonMode = .always
        textField.borderStyle = .line
         textField.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 24)
         textField.translatesAutoresizingMaskIntoConstraints = false
         return textField
    }()

    private let searchButton: UIButton = {
       let btn = UIButton()
        btn.setTitle(NewsSearchScreenView.searchButtonTitleText, for: .normal)
        btn.backgroundColor = .systemGreen
        btn.titleLabel?.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 24)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return btn
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private helpers

    private func setViews() {
        self.addSubview(textField)
        self.addSubview(searchButton)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            textField.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            textField.bottomAnchor.constraint(equalTo: searchButton.topAnchor, constant: -50),
            searchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            searchButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }

    // Method that will execute when user will click on the search button
    @objc
    private func searchButtonTapped() {
        guard let userInputText = textField.text, !userInputText.isEmpty else {
            print("#### empty text enterred!")
            return
        }

        delegate?.searchButtonTapped(withText: userInputText)
    }
}

