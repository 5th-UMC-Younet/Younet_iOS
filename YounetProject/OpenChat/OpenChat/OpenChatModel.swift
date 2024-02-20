//
//  OpenChatModel.swift
//  YounetProject
//
//  Created by 조혠 on 2/17/24.
//

import Foundation
struct OpenChatModel: Codable {
    let chatRoomId: Int?
    let title: String?
    let thumbnail: String?
    let message: String?
    let createdAt: String?
    let participants: Int?
}
struct OpenSearchModel: Codable {
    let content: [ChatRoom]
    let pageable: Pageable
    let totalElements: Int
    let totalPages: Int
    let last: Bool
    let size: Int
    let number: Int
    let sort: Sort
    let numberOfElements: Int
    let first: Bool
    let empty: Bool
}

struct ChatRoom: Codable {
    let chatRoomId: Int
    let title: String
    let thumbnail: String
    let description: String
    let participants: Int
}

struct Pageable: Codable {
    let pageNumber: Int
    let pageSize: Int
    let sort: Sort
    let offset: Int
    let paged: Bool
    let unpaged: Bool
}

struct Sort: Codable {
    let empty: Bool
    let unsorted: Bool
    let sorted: Bool
}

