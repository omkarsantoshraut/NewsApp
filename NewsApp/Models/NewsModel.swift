//
//  NewsModel.swift
//  NewsDemoApp
//
//  Created by Omkar Raut on 08/02/24.
//

import Foundation

struct NewsModel: Codable {
    let articles: [article]
    let status: String
    let totalResults: Int
}

struct article: Codable {
    let source: articleSource
    let author: String?
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

struct articleSource: Codable {
    let id: String?
    let name: String
}
