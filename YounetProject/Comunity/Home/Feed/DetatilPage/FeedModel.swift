//
//  FeedModel.swift
//  YounetProject
//
//  Created by 조혠 on 2/11/24.
//

import Foundation
struct FeedModel: Codable {
    let content: [Content]?
    let size: Int?
    let number: Int?
    let first: Bool?
    let last: Bool?
    let numberOfElements: Int?
}
struct Content: Codable {
    let postId: Int?
    let title: String?
    let bodySample: String?
    let imageSampleUrl: String?
    let categoryName: String?
    let likesCount: Int?
    let createdAt: String?
    let commentsCount: Int?
}

