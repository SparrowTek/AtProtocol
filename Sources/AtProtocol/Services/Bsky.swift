import SwiftData

@APActor
public struct BskyLexicons: Sendable {
    private let router: NetworkRouter<BskyAPI> = {
        let router = NetworkRouter<BskyAPI>(decoder: .atDecoder)
        router.delegate = APEnvironment.current.routerDelegate
        return router
    }()
    
    public init() {}
    
    public func getFeedGenerators(for feeds: [String]) async throws -> Feeds {
        try await router.execute(.getFeedGenerators(feeds: feeds))
    }
    
    public func getPreferences() async throws -> Preferences {
        try await router.execute(.getPreferences)
    }
    
    public func getProfile(for did: String) async throws -> Profile {
        try await router.execute(.getProfile(did: did))
    }
    
    // TODO: implement getFollows
    public func getFollows() {
        
        //https://bsky.social/xrpc/app.bsky.graph.getFollows?actor=did%3Aplc%3Aaq5iwu4gjdcg2hq53llism3x&limit=100
    }
    
    public func getTimeline(limit: Int) async throws -> Timeline {
        try await router.execute(.getTimeline(limit: limit))
    }
}

