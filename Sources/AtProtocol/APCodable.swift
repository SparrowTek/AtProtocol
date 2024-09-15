//
//  APCodable.swift
//  AtProtocol
//
//  Created by Thomas Rademaker on 9/15/24.
//

protocol APCodable: APEncodable, APDecodable, Sendable {}
protocol APEncodable: Encodable, Sendable {}
protocol APDecodable: Decodable, Sendable {}
