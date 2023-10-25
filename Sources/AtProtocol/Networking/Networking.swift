//
//  Networking.swift
//
//
//  Created by Thomas Rademaker on 8/30/23.
//

import Foundation

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
        routerDelegate.accessToken = accessToken
    }
}

var refreshToken: String? {
    didSet {
        routerDelegate.refreshToken = refreshToken
    }
}

var atProtocoldelegate: ATProtocolDelegate? {
    didSet {
        routerDelegate.delegate = atProtocoldelegate
    }
}

let routerDelegate = AtProtoRouterDelegate()

class AtProtoRouterDelegate: NetworkRouterDelegate {
    var accessToken: String?
    var refreshToken: String?
    weak var delegate: ATProtocolDelegate?
    private var shouldRefreshToken = false
    
    func intercept(_ request: inout URLRequest) async {
        if let refreshToken, shouldRefreshToken {
            shouldRefreshToken = false
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        } else if let accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
    
    func shouldRetry(error: Error, attempts: Int) async throws -> Bool {
        func getNewToken() async throws -> Bool {
            shouldRefreshToken = true
            let newSession = try await AtProtoLexicons().refresh()
            accessToken = newSession.accessJwt
            refreshToken = newSession.refreshJwt
            await delegate?.sessionUpdated(newSession)
            
            return true
        }
        
        if case .statusCode(let statusCode, _) = error as? NetworkError, let statusCode = statusCode?.rawValue, (400..<500).contains(statusCode), attempts == 1 {
            return try await getNewToken()
        } else if case .message(let message) = error as? AtError, message.error == AtErrorType.expiredToken.rawValue {
            return try await getNewToken()
        }
        
        return false
    }
}
