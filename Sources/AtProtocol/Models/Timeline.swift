import Foundation

public struct Timeline: Codable {
    public var feed: [TimelineItem]
    public var cursor: String
}

public struct TimelineItem: Codable {
    public let post: Post
    public let reply: Reply
}

public struct Post: Codable {
    public let uri: String
    public let cid: String
    public let author: Author
    public let record: Record
    public let replyCount: Int
    public let repostCount: Int
    public let likeCount: Int
    public let indexedAt: String
    public let viewer: Viewer
    public let labels: [String]
}

public struct Reply: Codable {
    public let root: Root
    public let parent: Parent
}

public struct Author: Codable {
    public let did: String
    public let handle: String
    public let displayName: String
    public let avatar: String
    public let viewer: Viewer
    public let labels: [String]
}

public struct Record: Codable {
    public let text: String
    public let type: String
    public let langs: [String]
    public let reply: ReplyDetail
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case type = "$type"
        case langs, reply, createdAt
    }
}

public struct ReplyDetail: Codable {
    public let root: RootDetail
    public let parent: ParentDetail
}

public struct RootDetail: Codable {
    public let cid: String
    public let uri: String
}

public struct ParentDetail: Codable {
    public let cid: String
    public let uri: String
}

public struct Root: Codable {
    public let type: String
    public let uri: String
    public let cid: String
    public let author: Author
    public let record: Record
    public let replyCount: Int
    public let repostCount: Int
    public let likeCount: Int
    public let indexedAt: String
    public let viewer: Viewer
    public let labels: [String]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case uri, cid, author, record, replyCount, repostCount, likeCount, indexedAt, viewer, labels
    }
}

public struct Parent: Codable {
    public let type: String
    public let uri: String
    public let cid: String
    public let author: Author
    public let record: Record
    public let replyCount: Int
    public let repostCount: Int
    public let likeCount: Int
    public let indexedAt: String
    public let viewer: Viewer
    public let labels: [String]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case uri, cid, author, record, replyCount, repostCount, likeCount, indexedAt, viewer, labels
    }
}
