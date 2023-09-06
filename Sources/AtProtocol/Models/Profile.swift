import Foundation

public struct Profile: Codable {
    public let did: String
    public var handle: String
    public var displayName: String
    public var description: String
    public var avatar: String
    public var banner: String
    public var followsCount: Int
    public var followersCount: Int
    public var postsCount: Int
    public var indexedAt: Date
    public var viewer: ProfileViewer
    public var labels: [String]
}

public struct ProfileViewer: Codable {
    public var muted: Bool
    public var blockedBy: Bool
    
    public init(muted: Bool, blockedBy: Bool) {
        self.muted = muted
        self.blockedBy = blockedBy
    }
}
