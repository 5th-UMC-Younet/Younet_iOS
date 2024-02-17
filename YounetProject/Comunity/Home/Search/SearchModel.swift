//
//  SearchModel.swift
//  YounetProject
//
//  Created by 조혠 on 2/13/24.
//

import Foundation
struct SearchModel: Codable {
    let categoryName: String?
    let postListResultDTOS: [Search]?
}
struct Search: Codable {
    let postId: Int?
    let title: String?
    let bodySample: String?
    let imageSampleUrl: String?
    let categoryName: String?
    let likesCount: Int?
    let createdAt: String?
    let commentsCount: Int?
}
struct SearchDetailModel: Codable {
    let content: [SearchDetailContent]?
    let size: Int?
    let number: Int?
    let first: Bool?
    let last: Bool?
    let numberOfElements: Int?
}

struct SearchDetailContent: Codable {
    let postId: Int?
    let title: String?
    let bodySample: String?
    let imageSampleUrl: String?
    let categoryName: String?
    let likesCount: Int?
    let createdAt: String?
    let commentsCount: Int?
}

