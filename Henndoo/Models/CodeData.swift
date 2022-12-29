// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let codeData = try? newJSONDecoder().decode(CodeData.self, from: jsonData)

import Foundation

// MARK: - CodeData
struct CodeData: Codable {
    let code, msg: String
}

extension CodeData {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(CodeData.self, from: data)
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
        code: String? = nil,
        msg: String? = nil
    ) -> CodeData {
        return CodeData(
            code: code ?? self.code,
            msg: msg ?? self.msg
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
