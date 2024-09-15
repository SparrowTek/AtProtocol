import Foundation

public struct Preferences: APCodable {
    public var preferences: [Preference]
}

public struct Preference: APCodable {
    public let type: String
    public var saved: [String]
    public var pinned: [String]
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case saved
        case pinned
    }
}
