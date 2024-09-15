import Foundation

enum AtProtoAPI {
    case login(identifier: String, password: String)
    case getCurrent
    case refresh
    case getAccountInviteCodes
}

extension AtProtoAPI: EndpointType {
    public var baseURL: URL {
        get async {
            guard let host = await APEnvironment.current.host else { fatalError("Host not set.") }
            guard let url = URL(string: host) else { fatalError("ATProto baseURL not configured.") }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .login: "/xrpc/com.atproto.server.createSession"
        case .getCurrent: "/xrpc/com.atproto.server.getSession"
        case .refresh: "/xrpc/com.atproto.server.refreshSession"
        case .getAccountInviteCodes: "/xrpc/com.atproto.server.getAccountInviteCodes"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .login, .refresh:
            return .post
        case .getCurrent, .getAccountInviteCodes:
            return .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .login(let identifier, let password):
            let loginObject = LoginObject(identifier: identifier, password: password)
            return .requestParameters(encoding: .jsonEncodableEncoding(encodable: loginObject))
        case .getCurrent, .refresh, .getAccountInviteCodes:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
}
