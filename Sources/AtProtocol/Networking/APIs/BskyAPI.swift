import Foundation

enum BskyAPI {
    case getFeedGenerators(feeds: [String])
    case getPreferences
    case getProfile(did: String)
    case getFollows
    case getTimeline(limit: Int)
}

extension BskyAPI: EndpointType {
    public var baseURL: URL {
        guard let host else { fatalError("You must call the update(hostURL: String) method and set the host before continuing with API requests")}
        guard let url = URL(string: host) else { fatalError("baseURL not configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .getFeedGenerators: "/xrpc/app.bsky.feed.getFeedGenerators"
        case .getPreferences: "/xrpc/app.bsky.actor.getPreferences"
        case .getProfile: "/xrpc/app.bsky.actor.getProfile"
        case .getFollows: ""
        case .getTimeline: "/xrpc/app.bsky.feed.getTimeline"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getFeedGenerators, .getPreferences, .getProfile, .getFollows, .getTimeline:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getFeedGenerators(let feeds):
            var parameters: Parameters = [:]
            for feed in feeds {
                
            }
            return .requestParameters(encoding: .urlEncoding(parameters: parameters))
        case .getPreferences, .getFollows:
            return .request
        case .getProfile(let did):
            return .requestParameters(encoding: .urlEncoding(parameters: ["actor" : did]))
        case .getTimeline(let limit):
            return .requestParameters(encoding: .urlEncoding(parameters: ["limit" : limit]))
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
