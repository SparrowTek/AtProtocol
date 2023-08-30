public struct Session: Codable {
    public let did: String
    public let handle: String
    public let email: String
    public let accessJwt: String
    public let refreshJwt: String
}
