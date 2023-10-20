
public struct Creator: Codable, Sendable {
    public let did: String
    public var handle: String
    public var displayName: String
    public var avatar: String
    public var viewer: Viewer
    public var labels: [String]
}
