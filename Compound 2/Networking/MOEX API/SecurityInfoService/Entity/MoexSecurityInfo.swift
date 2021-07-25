//
//  MoexSecurityInfo.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//   let securities = try? newJSONDecoder().decode(Securities.self, from: jsonData)

// MARK: - Securities
struct Securities: Codable {
    let securities: SecuritiesInfo
}

// MARK: - SecuritiesClass
struct SecuritiesInfo: Codable {
    let columns: [String]
    let data: [[SecurityInfo]]
}

enum SecurityInfo: Codable {
    case double(Double)
    case string(String)
    case null

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if container.decodeNil() {
            self = .null
            return
        }
        throw DecodingError.typeMismatch(SecurityInfo.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .null:
            try container.encodeNil()
        }
    }
}
