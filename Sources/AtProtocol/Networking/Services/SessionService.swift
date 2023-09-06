import Get

public struct SessionService {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public init() {}
    
    public func login(identifier: String, password: String) async throws -> Session {
        let loginObject = LoginObject(identifier: identifier, password: password)
        return try await apiClient.send(Request(path: "/xrpc/com.atproto.server.createSession", method: .post, body: loginObject)).value
    }
    
    func getCurrent() async throws -> Session {
        try await apiClient.send(Request(path: "/xrpc/com.atproto.server.getSession")).value
    }
    
    func refresh() async throws -> Session {
        try await apiClient.send(Request(path: "/xrpc/com.atproto.server.refreshSession", method: .post)).value
    }
}
