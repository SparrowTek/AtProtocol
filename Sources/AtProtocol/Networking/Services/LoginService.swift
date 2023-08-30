import Get

public struct LoginService {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public func login(identifier: String, password: String) async throws -> Session {
        let loginObject = LoginObject(identifier: identifier, password: password)
        return try await apiClient.send(Request(path: "/xrpc/com.atproto.server.createSession", method: .post, body: loginObject)).value
    }
}
