import Foundation
import SwiftData
import Get

public protocol LexiconsDelegate: AnyObject {
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws
    func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool
    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws
    func client<T>(_ client: APIClient, makeURLForRequest request: Request<T>) throws -> URL?
}

@Observable
public class Lexicons {
    public init() {}
    
    public let loginService = LoginService()
}
