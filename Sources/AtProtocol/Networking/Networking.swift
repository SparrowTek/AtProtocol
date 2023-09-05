//
//  Networking.swift
//  
//
//  Created by Thomas Rademaker on 8/30/23.
//

import Foundation
import Get

typealias Query = [(String, String?)]?

extension JSONDecoder {
    static var atDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }
}

extension JSONEncoder {
    static var atEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        
        return encoder
    }
}

func shouldPerformRequest(lastFetched: Double, timeLimit: Int = 3600) -> Bool {
    guard lastFetched != 0 else { return true }
    let currentTime = Date.now
    let lastFetchTime = Date(timeIntervalSince1970: lastFetched)
    guard let differenceInMinutes = Calendar.current.dateComponents([.second], from: lastFetchTime, to: currentTime).second else { return false }
    return differenceInMinutes >= timeLimit
}

var host: String?
var session: Session?
var atProtocoldelegate: ATProtocolDelegate?

var configuration: APIClient.Configuration {
    guard let host else { fatalError("You must call the update(hostURL: String) method and set the host before continuing with API requests")}
    let apiClientDelegate = ATAPIClientDelegate(session: session)
    apiClientDelegate.delegate = atProtocoldelegate
    var config = APIClient.Configuration(baseURL: URL(string: host), delegate: apiClientDelegate)
    config.decoder = .atDecoder
    config.encoder = .atEncoder
    return config
}

class ATAPIClientDelegate: APIClientDelegate {
    var session: Session?
    var refreshToken = ""
    weak var delegate: ATProtocolDelegate?
    
    init(session: Session?) {
        self.session = session
    }
    
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        if let session {
            request.setValue("Bearer \(session.accessJwt)", forHTTPHeaderField: "Authorization")
        } else if !refreshToken.isEmpty {
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        }
    }

    func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool {
        if case .unacceptableStatusCode(let statusCode) = error as? APIError, (400..<500).contains(statusCode), attempts == 1 {
            refreshToken = session?.refreshJwt ?? ""
            session = nil
            let newSession = try await SessionService().refresh()
            session = newSession
            delegate?.sessionUpdated(newSession)
            
            return true
        }
        
        return false
    }

    func client(_ client: APIClient, validateResponse response: HTTPURLResponse, data: Data, task: URLSessionTask) throws {
        guard (200..<300).contains(response.statusCode) else {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { throw APIError.unacceptableStatusCode(response.statusCode) }
            throw AtError.message(errorMessage)
        }
    }

    func client<T>(_ client: APIClient, makeURLForRequest request: Request<T>) throws -> URL? {
        nil // Use default handlings
    }
}
