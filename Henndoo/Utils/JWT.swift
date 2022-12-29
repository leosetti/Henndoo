//
//  JWT.swift
//  Henndoo
//
//  Created by Leandro Setti de Almeida on 2022-07-28.
//

import Foundation

func decode(jwtToken jwt: String) throws -> [String: Any] {
    enum DecodeErrors: Error {
        case missingToken
        case badToken
        case other
    }

    func base64Decode(_ base64: String) throws -> Data {
        let base64 = base64
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
        guard let decoded = Data(base64Encoded: padded) else {
            throw DecodeErrors.badToken
        }
        return decoded
    }

    func decodeJWTPart(_ value: String) throws -> [String: Any] {
        let bodyData = try base64Decode(value)
        let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
        guard let payload = json as? [String: Any] else {
            throw DecodeErrors.other
        }
        return payload
    }

    let segments = jwt.components(separatedBy: ".")
    guard segments.count>1 else {
        throw DecodeErrors.other
    }
    return try decodeJWTPart(segments[1])
}
