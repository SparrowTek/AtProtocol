public enum AtError: Error {
    case message(ErrorMessage)
}

public struct ErrorMessage: Codable {
    #warning("Should error be type string or AtErrorType?")
    public let error: String
    public let message: String
    
    public init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}

public enum AtErrorType: String, Codable {
    case authenticationRequired = "AuthenticationRequired"
}