public protocol ATProtocolDelegate {
    func sessionUpdated(_ session: Session)
}

public func setup(hostURL: String, userSession: Session, delegate: ATProtocolDelegate? = nil) {
    host = hostURL
    session = userSession
    atProtocoldelegate = delegate
}

public func setDelegate(_ delegate: ATProtocolDelegate) {
    atProtocoldelegate = delegate
}

public func update(userSession: Session?) {
    session = userSession
}

public func update(hostURL: String?) {
    host = hostURL
}
