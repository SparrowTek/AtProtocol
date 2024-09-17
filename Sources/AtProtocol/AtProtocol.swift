
public protocol ATProtocolDelegate: AnyObject {
    func sessionUpdated(_ session: Session) async
}

@APActor
public func setup(hostURL: String?, accessJWT: String?, refreshJWT: String?, delegate: ATProtocolDelegate? = nil) {
    APEnvironment.current.host = hostURL
    APEnvironment.current.accessToken = accessJWT
    APEnvironment.current.refreshToken = refreshJWT
    APEnvironment.current.atProtocoldelegate = delegate
}

@APActor
public func setDelegate(_ delegate: ATProtocolDelegate) {
    APEnvironment.current.atProtocoldelegate = delegate
}

@APActor
public func updateTokens(access: String?, refresh: String?) {
    APEnvironment.current.accessToken = access
    APEnvironment.current.refreshToken = refresh
}

@APActor
public func update(hostURL: String?) {
    APEnvironment.current.host = hostURL
}
