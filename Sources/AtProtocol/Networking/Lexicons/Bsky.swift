import SwiftData
import Get

@Observable
public class BskyLexicons {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public init() {}
    
    public func getFeedGenerators(for feeds: [String]) async throws -> Feeds {
        var query: Query = []
        
        for feed in feeds {
            query?.append(("feeds", feed))
        }

        return try await apiClient.send(Request(path: "/xrpc/app.bsky.feed.getFeedGenerators", query: query)).value
    }
    
    public func getPreferences() async throws -> Preferences {
        try await apiClient.send(Request(path: "/xrpc/app.bsky.actor.getPreferences")).value
    }
    
    public func getProfile(for did: String) async throws -> Profile {
        try await apiClient.send(Request(path: "/xrpc/app.bsky.actor.getProfile",  query: [("actor", did)])).value
    }
    
    // TODO: implement getFollows
    public func getFollows() {
        
        //https://bsky.social/xrpc/app.bsky.graph.getFollows?actor=did%3Aplc%3Aaq5iwu4gjdcg2hq53llism3x&limit=100
    }
    
    public func getTimeline(limit: Int) async throws -> Timeline {
        try await apiClient.send(Request(path: "/xrpc/app.bsky.feed.getTimeline", query: [("limit", "\(limit)")])).value
    }
}

