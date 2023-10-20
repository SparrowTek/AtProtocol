public struct Viewer: Codable, Sendable {
    public var muted: Bool?
    public var blockedBy: Bool?
    public var following: String?
    public var followedBy: String?
    
    public init(muted: Bool?, blockedBy: Bool?, following: String?, followedBy: String?) {
        self.muted = muted
        self.blockedBy = blockedBy
        self.following = following
        self.followedBy = followedBy
    }
}
