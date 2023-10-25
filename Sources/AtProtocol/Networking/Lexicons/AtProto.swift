import SwiftData

@Observable
public class AtProtoLexicons {
    private let router = NetworkRouter<AtProtoAPI>(decoder: .atDecoder)
    
    public init() {}
    
    public func login(identifier: String, password: String) async throws -> Session {
        try await router.execute(.login(identifier: identifier, password: password))
    }
    
    public func getCurrent() async throws -> Session {
        try await router.execute(.getCurrent)
    }
    
    func refresh() async throws -> Session {
        try await router.execute(.refresh)
    }
    
    // TODO: implement getAccountInviteCodes
    func getAccountInviteCodes() {
//    https://bsky.social/xrpc/com.atproto.server.getAccountInviteCodes
    }
}
