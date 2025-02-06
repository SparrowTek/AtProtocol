import Foundation
import OAuthenticator
import JWTKit
import CryptoKit

@APActor
public struct AtProtoLexicons: Sendable {
    private let router: NetworkRouter<AtProtoAPI>
    private var keys: JWTKeyCollection
    private var privateKey: ES256PrivateKey
    
    public init() async {
        self.router = {
            let router = NetworkRouter<AtProtoAPI>(decoder: .atDecoder)
            router.delegate = APEnvironment.current.routerDelegate
            return router
        }()
        
        // Create keys once during initialization
        self.privateKey = ES256PrivateKey()
        self.keys = JWTKeyCollection()
        // Add the key to the collection
        await self.keys.add(ecdsa: privateKey)
    }
    
    public func login(account: String, clientMetadataEndpoint: String) async throws {
        let provider = URLSession.defaultProvider
        let host = APEnvironment.current.host ?? ""
        let server = if host.hasPrefix("https://") {
            String(host.dropFirst(8))
        } else if host.hasPrefix("http://") {
            String(host.dropFirst(7))
        } else { host }

        let clientConfig = try await ClientMetadata.load(for: clientMetadataEndpoint, provider: provider)
        let serverConfig = try await ServerMetadata.load(for: server, provider: provider)
        
        // Create storage for persisting login state
        let loginStorage = LoginStorage {
            // Implement retrieving stored login
            // Return stored Login if it exists, or nil
            return nil
        } storeLogin: { login in
            // Implement storing the login
            // Store the login securely
            
            print("LOGIN: \(login)")
        }

        let jwtGenerator: DPoPSigner.JWTGenerator = { params in
            try await self.generateJWT(params: params)
        }

        let tokenHandling = Bluesky.tokenHandling(account: account, server: serverConfig, jwtGenerator: jwtGenerator)
        let config = Authenticator.Configuration(appCredentials: clientConfig.credentials, loginStorage: loginStorage, tokenHandling: tokenHandling, mode: .automatic)
        let authenticator = Authenticator(config: config)
        try await authenticator.authenticate()
    }
    
    private func generateJWT(params: DPoPSigner.JWTParameters) async throws -> String {
        // Create DPoP payload using existing keys
        let payload = DPoPPayload(
            htm: params.httpMethod,
            htu: params.requestEndpoint,
            iat: .init(value: .now),
            jti: .init(value: UUID().uuidString),
            nonce: params.nonce
        )
        
        // Sign with existing keys
        return try await self.keys.sign(payload)
    }
    
//    public func getCurrent() async throws -> Session {
//        try await router.execute(.getCurrent)
//    }
//    
//    func refresh(attempts: Int = 1) async throws -> Session {
//        try await router.execute(.refresh, attempts: attempts)
//    }
//    
//    // TODO: implement getAccountInviteCodes
//    func getAccountInviteCodes() {
////    https://bsky.social/xrpc/com.atproto.server.getAccountInviteCodes
//    }
}

private struct DPoPPayload: JWTPayload {
    let htm: String
    let htu: String
    let iat: IssuedAtClaim
    let jti: IDClaim
    let nonce: String?
    
    func verify(using key: some JWTAlgorithm) throws {
        // No additional verification needed
    }
}

/*
@APActor
public struct AtProtoLexicons: Sendable {
    private let router: NetworkRouter<AtProtoAPI> = {
        let router = NetworkRouter<AtProtoAPI>(decoder: .atDecoder)
        router.delegate = APEnvironment.current.routerDelegate
        return router
    }()
    
    public init() {}
    
    public func login(identifier: String, password: String) async throws -> Session {
        try await router.execute(.login(identifier: identifier, password: password))
    }
    
    public func getCurrent() async throws -> Session {
        try await router.execute(.getCurrent)
    }
    
    func refresh(attempts: Int = 1) async throws -> Session {
        try await router.execute(.refresh, attempts: attempts)
    }
    
    // TODO: implement getAccountInviteCodes
    func getAccountInviteCodes() {
//    https://bsky.social/xrpc/com.atproto.server.getAccountInviteCodes
    }
}
 */
/*
client_id (string, required): must exactly match the full URL used to fetch the client metadata JSON itself
application_type (string, optional): must be one of web (default) or native
grant_types (array of strings, required): usually authorization_code and refresh_token
scope (string, sub-strings space-separated, required): any scope values which might be requested by this client are declared here. The atproto scope is required.
response_types (array of strings, required): usually just code.
redirect_uris (array of strings, required): the fully-qualified redirect/callback URL is declared here.
dpop_bound_access_tokens (boolean, required): must be true (DPoP is mandatory)
token_endpoint_auth_method (string, optional): confidential clients must set this to private_key_jwt.
token_endpoint_auth_signing_alg (string, optional): confidential client set this to ES256
jwks (object with array of JWKs, optional) or jwks_uri (string URL, optional): confidential clients must supply at least one public key in JWK format for use with JWT client authentication.
And some optional (but recommended) metadata fields:

client_name (string, optional): human-readable name of the client
client_uri (string, optional): not to be confused with client_id, this is a homepage URL for the client. If provided, the client_uri must have the same hostname as client_id.
logo_uri (string, optional): HTTP URL to client logo
tos_uri (string, optional): HTTP URL to human-readable terms of service ("ToS") for the client
policy_uri (string, optional): HTTP URL to human-readable privacy policy for the client
*/
