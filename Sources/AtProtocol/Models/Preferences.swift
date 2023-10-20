import Foundation

public struct Preferences: Codable, Sendable {
    public var preferences: [Preference]
}

public struct Preference: Codable, Sendable {
    public let type: String
    public var saved: [String]
    public var pinned: [String]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case saved
        case pinned
    }
}
