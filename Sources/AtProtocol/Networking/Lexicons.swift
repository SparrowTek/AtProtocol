import SwiftData
import Get

@Observable
public class Lexicons {
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
    
    public func login(identifier: String, password: String) async throws -> Session {
        let loginObject = LoginObject(identifier: identifier, password: password)
        return try await apiClient.send(Request(path: "/xrpc/com.atproto.server.createSession", method: .post, body: loginObject)).value
    }
    
    public func getCurrent() async throws -> Session {
        try await apiClient.send(Request(path: "/xrpc/com.atproto.server.getSession")).value
    }
    
    func refresh() async throws -> Session {
        try await apiClient.send(Request(path: "/xrpc/com.atproto.server.refreshSession", method: .post)).value
    }
}
