import Get

public struct FeedService {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public init() {}
    
    public func getFeedGenerators() async throws -> Feed {
        try await apiClient.send(Request(path: "/xrpc/app.bsky.feed.getFeedGenerators")).value
    }
}
