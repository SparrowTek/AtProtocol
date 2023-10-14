import SwiftData
import Get

@Observable
public class AtProtoLexicons {
    private var apiClient: APIClient { APIClient(configuration: configuration) }
    
    public init() {}
    
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
    
    // TODO: implement getAccountInviteCodes
    func getAccountInviteCodes() {
//    https://bsky.social/xrpc/com.atproto.server.getAccountInviteCodes
    }
}
