public enum AtError: Error {
    case message(ErrorMessage)
    case network(NetworkError)
}

public struct ErrorMessage: APCodable {
    #warning("Should error be type string or AtErrorType?")
    public let error: String
    public let message: String?
    
    public init(error: String, message: String?) {
        self.error = error
        self.message = message
    }
}

public enum AtErrorType: String, APCodable {
    case authenticationRequired = "AuthenticationRequired"
    case expiredToken = "ExpiredToken"
    case invalidRequest = "InvalidRequest"
    case methodNotImplemented = "MethodNotImplemented"
    case rateLimitExceeded = "RateLimitExceeded"
    case authMissing = "AuthMissing"
}
