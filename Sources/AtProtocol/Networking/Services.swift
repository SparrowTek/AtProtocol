import SwiftData

@Observable
public class Services {
    public init() {}
    
    public let loginService = LoginService()
}
