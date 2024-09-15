@preconcurrency import Foundation

@APActor
protocol Networking {
    func data(for request: URLRequest, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: Networking { }
