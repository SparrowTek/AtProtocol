import SwiftData

@APActor
public struct AtProtoLexicons: Sendable {
    private let router: NetworkRouter<AtProtoAPI> = {
        let router = NetworkRouter<AtProtoAPI>(decoder: .atDecoder)
        router.delegate = APEnvironment.current.routerDelegate
        return router
    }()
    
    public init() {}
    
    public func login(identifier: String, password: String) async throws -> Session {
        try await router.execute(.login(identifier: identifier, password: password))
    }
    
    public func getCurrent() async throws -> Session {
        try await router.execute(.getCurrent)
    }
    
    func refresh(attempts: Int = 1) async throws -> Session {
        try await router.execute(.refresh, attempts: attempts)
    }
    
    // TODO: implement getAccountInviteCodes
    func getAccountInviteCodes() {
//    https://bsky.social/xrpc/com.atproto.server.getAccountInviteCodes
    }
}
