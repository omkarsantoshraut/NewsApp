//
//  ScreenTabsViewController.swift
//  NewsApp
//
//  Created by Omkar Raut on 21/12/25.
//

import Foundation
import UIKit

class ScreenTabsViewController: UITabBarController {

    // MARK: - Constants

    let topHeadlinesNavController = UINavigationController(rootViewController: TopHeadlinesViewController())

    // MARK: - Initializers

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            topHeadlinesNavController
        ]

        selectedIndex = 0
        setup()
    }

    // MARK: - Private Helpers

    private func setup() {
        topHeadlinesNavController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house.fill"),
            tag: 0)
    }
}
