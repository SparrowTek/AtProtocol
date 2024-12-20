import Foundation

public struct Profile: APCodable {
    public let did: String
    public var handle: String
    public var displayName: String
    public var description: String
    public var avatar: String
    public var banner: String
    public var followsCount: Int
    public var followersCount: Int
    public var postsCount: Int
    public var indexedAt: String // TODO: should be a date but not decoding properly
    public var viewer: Viewer
    public var labels: [String]
}
