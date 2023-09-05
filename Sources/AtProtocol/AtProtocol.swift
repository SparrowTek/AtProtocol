public func setup(hostURL: String, userSession: Session) {
    host = hostURL
    session = userSession
}

public func update(userSession: Session?) {
    session = userSession
}

public func update(hostURL: String?) {
    host = hostURL
}
