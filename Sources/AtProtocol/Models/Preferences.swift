import Foundation

public struct Preferences: Codable {
    public var preferences: [Preference]
}

public struct Preference: Codable {
    public let type: String
    public var saved: [String]
    public var pinned: [String]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case saved
        case pinned
    }
}
