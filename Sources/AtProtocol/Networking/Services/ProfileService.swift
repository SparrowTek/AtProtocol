import Get

public struct ProfileService {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public init() {}
    
    public func getProfile(for did: String) async throws -> Profile {
        try await apiClient.send(Request(path: "/xrpc/app.bsky.actor.getProfile",  query: [("actor", did)])).value
    }
}
