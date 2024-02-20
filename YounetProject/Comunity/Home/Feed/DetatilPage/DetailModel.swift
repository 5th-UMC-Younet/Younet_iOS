//
//  DetailModel.swift
//  YounetProject
//
//  Created by 조혠 on 2/11/24.
//

import Foundation
struct DetailModel: Codable {
    let httpStatus: String
    let message: String
    let data: DetailData
}

struct DetailData: Codable {
    //let authorCommuProfId: Int
    let authorName: String
    let postId: Int
    let postTitle: String
    let likesCount: Int
    let sections: [Section]
}

struct Section: Codable {
    let sectionId: Int
    let body: String
    let images: [Image]
}

struct Image: Codable {
    let imageId: Int
    let imageUrl: String
}
//comment
struct CommentModel: Codable {
    let content: [Comment]?
    let size: Int?
    let number: Int?
    let first: Bool?
    let last: Bool?
    let numberOfElements: Int?
}

struct Comment: Codable {
    let commentId: Int?
    let postId: Int?
    let communityProfileId: Int?
    let authorName: String?
    let body: String?
    let createdAt: String?
    let updatedAt: String?
    let replyList: [Reply]?
}
struct Reply: Codable {
    let replyId: Int?
    let commentId: Int?
    let postId: Int?
    let communityProfileId: Int?
    let authorName: String?
    let body: String?
    let createdAt: String?
    let updatedAt: String?
}

