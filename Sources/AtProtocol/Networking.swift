//
//  Networking.swift
//  AtProtocol
//
//  Created by Thomas Rademaker on 9/15/24.
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

@APActor
class APRouterDelegate: NetworkRouterDelegate {
    weak var delegate: ATProtocolDelegate?
    private var shouldRefreshToken = false
    
    func intercept(_ request: inout URLRequest) async {
        if let refreshToken = APEnvironment.current.refreshToken, shouldRefreshToken {
            shouldRefreshToken = false
            request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        } else if let accessToken = APEnvironment.current.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
    }
    
    func shouldRetry(error: Error, attempts: Int) async throws -> Bool {
        func getNewToken() async throws -> Bool {
            shouldRefreshToken = true
            let newSession = try await AtProtoLexicons().refresh(attempts: attempts + 1)
            APEnvironment.current.accessToken = newSession.accessJwt
            APEnvironment.current.refreshToken = newSession.refreshJwt
            await delegate?.sessionUpdated(newSession)
            
            return true
        }
        
        // TODO: verify this works!
        if case .network(let networkError) = error as? AtError, case .statusCode(let statusCode, _) = networkError, let statusCode = statusCode?.rawValue, (400..<500).contains(statusCode), attempts == 1 {
            return try await getNewToken()
        } else if case .message(let message) = error as? AtError, message.error == AtErrorType.expiredToken.rawValue {
            return try await getNewToken()
        }
        
        return false
    }
}
