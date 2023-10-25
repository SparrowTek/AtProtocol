public struct Session: Codable, Sendable {
    public let did: String
    public let handle: String
    public let email: String?
    public let accessJwt: String?
    public let refreshJwt: String?
    
    public init(did: String, handle: String, email: String?, accessJwt: String?, refreshJwt: String?) {
        self.did = did
        self.handle = handle
        self.email = email
        self.accessJwt = accessJwt
        self.refreshJwt = refreshJwt
    }
}

extension Session: Equatable {}
