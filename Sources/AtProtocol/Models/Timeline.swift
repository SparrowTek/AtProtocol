import Foundation

public struct Timeline: Codable, Sendable {
    public var feed: [TimelineItem]
    public var cursor: String
}

public struct TimelineItem: Codable, Sendable {
    public let post: Post
    public let reply: Reply?
}

extension TimelineItem: Equatable {
    public static func == (lhs: TimelineItem, rhs: TimelineItem) -> Bool {
        lhs.post.uri == rhs.post.uri && lhs.post.cid == rhs.post.cid
    }
}

extension TimelineItem: Identifiable {
    public var id: UUID {
        UUID()
    }
}

public struct Post: Codable, Sendable {
    public let uri: String
    public let cid: String
    public let author: Author
    public let record: Record
    public let facets: PostFacet?
    public let replyCount: Int
    public let repostCount: Int
    public let likeCount: Int
    public let indexedAt: String
    public let viewer: Viewer
    public let labels: [String]
    public let embed: Embed?
}

public struct PostFacet: Codable, Sendable {
    public let facets: [Facet]
    public let createdAt: Date
}

public struct Facet: Codable, Sendable {
    public let index: FacetIndex
    public let features: [FacetFeature]
    
}

public struct FacetFeature: Codable, Sendable {
    public let uri: String
    public let type: String
    
    enum CodingKeys: String, CodingKey {
        case uri
        case type = "$type"
    }
}

public struct FacetIndex: Codable, Sendable {
    public let byteEnd: Int
    public let byteStart: Int
}

public struct Embed: Codable, Sendable {
    public let type: String
    public let images: [EmbeddedMedia]?
    public let media: Media?
    public let record: EmbedRecord?
    public let external: EmbedExternal?
    
    enum CodingKeys: String, CodingKey {
        case images, media, record, external
        case type = "$type"
    }
}

public struct EmbedExternal: Codable, Sendable {
    public let uri: String
    public let thumb: TimelineImage?
    public let title: String
    public let externalDescription: String
    
    enum CodingKeys: String, CodingKey {
        case uri, thumb, title
        case externalDescription = "description"
    }
}

public struct EmbedRecord: Codable, Sendable {
    public let type: String?
    public let record: UnpopulatedPost?
    public let uri: String?
    public let cid: String?
    public let author: Author?
    public let value: EmbedRecordValue?
//    public let labels: [String]
//    public let indexedAt: Date
//    public let embeds: [String] // TODO: This isn't correct
    
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case record, uri, cid, author, value/*, labels, indexedAt, embeds*/
    }
}

public struct EmbedRecordValue: Codable, Sendable {
    public let text: String
    public let type: String
    public let langs: [String]
    public let reply: ReplyDetail?
    public let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case langs, reply, createdAt, text
    }
}

public struct Media: Codable, Sendable {
    public let type: String
    public let images: [EmbeddedMedia]?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case images
    }
}

public enum EmbedType: String, Codable {
    case image = "app.bsky.embed.images"
    case recordWithMedia = "app.bsky.embed.recordWithMedia"
    case external = "app.bsky.embed.external"
    case record = "app.bsky.embed.record"
}

public enum TimelineImage: Codable, Sendable, Identifiable {
    case string(String)
    case image(EmbeddedImage)
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let string = try? container.decode(String.self) {
            self = .string(string)
            return
        }
        
        if let image = try? container.decode(EmbeddedImage.self) {
            self = .image(image)
            return
        }
        
        throw DecodingError.typeMismatch(TimelineImage.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyProperty"))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .image(let image):
            try container.encode(image)
        }
    }
    
    public var id: UUID { UUID() }
}

public struct EmbeddedMedia: Codable, Sendable {
    public let thumb: TimelineImage?
    public let fullsize: String?
    public let alt: String
    public let aspectRatio: EmbedImageAspectRatio?
    public let image: TimelineImage?
}

public struct EmbeddedImage: Codable, Sendable {
    public let type: String
    public let ref: [String : String]
    public let mimeType: String
    public let size: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case ref, mimeType, size
    }
}

public struct EmbedImageAspectRatio: Codable, Sendable {
    public let width: Int
    public let height: Int
}

public struct Reply: Codable, Sendable {
    public let root: Root
    public let parent: Parent
}

public struct Author: Codable, Sendable {
    public let did: String
    public let handle: String
    public let displayName: String?
    public let avatar: String
    public let viewer: Viewer
    public let labels: [String]
}

public struct Record: Codable, Sendable {
    public let text: String
    public let type: String
    public let langs: [String]
    public let reply: ReplyDetail?
    public let createdAt: String
    public let embed: Embed?
    
    enum CodingKeys: String, CodingKey {
        case type = "$type"
        case langs, reply, createdAt, embed, text
    }
}

public struct ReplyDetail: Codable, Sendable {
    public let root: UnpopulatedPost
    public let parent: UnpopulatedPost
}

public struct UnpopulatedPost: Codable, Sendable {
    public let cid: String
    public let uri: String
}

public struct Root: Codable, Sendable {
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

public struct Parent: Codable, Sendable {
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
