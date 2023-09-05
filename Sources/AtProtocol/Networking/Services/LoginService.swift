import Get

public struct LoginService {
    public init() {}
    
    public func login(identifier: String, password: String) async throws -> Session {
        let loginObject = LoginObject(identifier: identifier, password: password)
        return try await APIClient(configuration: configuration).send(Request(path: "/xrpc/com.atproto.server.createSession", method: .post, body: loginObject)).value
    }
}
