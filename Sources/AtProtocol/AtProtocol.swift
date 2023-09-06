public protocol ATProtocolDelegate: AnyObject {
    func sessionUpdated(_ session: Session)
}

public func setup(hostURL: String, accessJWT: String, refreshJWT: String, delegate: ATProtocolDelegate? = nil) {
    host = hostURL
    accessToken = accessJWT
    refreshToken = refreshJWT
    atProtocoldelegate = delegate
}

public func setDelegate(_ delegate: ATProtocolDelegate) {
    atProtocoldelegate = delegate
}

public func updateTokens(access: String, refresh: String) {
    accessToken = access
    refreshToken = refresh
}

public func update(hostURL: String?) {
    host = hostURL
}
