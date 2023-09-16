import Foundation

public struct Feed: Codable {
    public var uri: String
    public var cid: String
    public let did: String
    public var creator: Creator
    public var displayName: String
    public var description: String
    public var avatar: String?
    public var likeCount: Int
    public var viewer: Viewer
    public var indexedAt: Date
}

public struct Feeds: Codable {
    public var feeds: [Feed]
}
