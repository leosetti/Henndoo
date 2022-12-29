// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userToken = try UserToken(json)

import Foundation

// MARK: - UserToken
struct UserToken: Codable {
    let aud, sub: String
    let iat: Int
    let username, iss, firstname: String
}

// MARK: UserToken convenience initializers and mutators

extension UserToken {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(UserToken.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        aud: String? = nil,
        sub: String? = nil,
        iat: Int? = nil,
        username: String? = nil,
        iss: String? = nil,
        firstname: String? = nil
    ) -> UserToken {
        return UserToken(
            aud: aud ?? self.aud,
            sub: sub ?? self.sub,
            iat: iat ?? self.iat,
            username: username ?? self.username,
            iss: iss ?? self.iss,
            firstname: firstname ?? self.firstname
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
