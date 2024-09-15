//
//  APEnvironment.swift
//  AtProtocol
//
//  Created by Thomas Rademaker on 9/15/24.
//

@APActor
class APEnvironment {
    static var current: APEnvironment = APEnvironment()
    
    var host: String?
    var accessToken: String?
    var refreshToken: String?
    var atProtocoldelegate: ATProtocolDelegate?
    let routerDelegate = APRouterDelegate()
    
    private init() {}
    
//    func setup(apiKey: String, apiSecret: String, userAgent: String) {
//        self.apiKey = apiKey
//        self.apiSecret = apiSecret
//        self.userAgent = userAgent
//    }
}

