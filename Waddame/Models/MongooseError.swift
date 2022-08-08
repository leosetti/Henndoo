// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let mongooseError = try? newJSONDecoder().decode(MongooseError.self, from: jsonData)

import Foundation

// MARK: - MongooseError
struct MongooseError: Codable {
    let original: Original
    let details: [Detail]

    enum CodingKeys: String, CodingKey {
        case original = "_original"
        case details
    }
}

// MARK: - Detail
struct Detail: Codable {
    let message: String
    let path: [String]
    let type: String
    let context: Context
}

// MARK: - Context
struct Context: Codable {
    let label, value, key: String
}

// MARK: - Original
struct Original: Codable {
    let password, login: String
}
