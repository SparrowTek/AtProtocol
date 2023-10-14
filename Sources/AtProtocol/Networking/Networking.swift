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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return decoder
    }
}

extension JSONEncoder {
    static var atEncoder: JSONEncoder {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
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
var accessToken: String? {
    didSet {
        apiClientDelegate.accessToken = accessToken
    }
}

var refreshToken: String? {
    didSet {
        apiClientDelegate.refreshToken = refreshToken
    }
}

var atProtocoldelegate: ATProtocolDelegate?

let apiClientDelegate = ATAPIClientDelegate()
var configuration: APIClient.Configuration {
    guard let host else { fatalError("You must call the update(hostURL: String) method and set the host before continuing with API requests")}
    apiClientDelegate.delegate = atProtocoldelegate
    var config = APIClient.Configuration(baseURL: URL(string: host), delegate: apiClientDelegate)
    config.decoder = .atDecoder
    config.encoder = .atEncoder
    return config
}

class ATAPIClientDelegate: APIClientDelegate {
    var accessToken: String?
    var refreshToken: String?
    weak var delegate: ATProtocolDelegate?
    private var shouldRefreshToken = false
    
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) async throws {
        if let refreshToken, shouldRefreshToken {
            shouldRefreshToken = false
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        } else if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }

    func client(_ client: APIClient, shouldRetry task: URLSessionTask, error: Error, attempts: Int) async throws -> Bool {
        func getNewToken() async throws -> Bool {
            shouldRefreshToken = true
            let newSession = try await AtProtoLexicons().refresh()
            accessToken = newSession.accessJwt
            refreshToken = newSession.refreshJwt
            await delegate?.sessionUpdated(newSession)
            
            return true
        }
        
        if case .unacceptableStatusCode(let statusCode) = error as? APIError, (400..<500).contains(statusCode), attempts == 1 {
            return try await getNewToken()
        } else if case .message(let message) = error as? AtError, message.error == AtErrorType.expiredToken.rawValue {
            return try await getNewToken()
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
