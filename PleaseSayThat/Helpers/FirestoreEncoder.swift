//
//  FirestoreEncoder.swift
//  PleaseSayThat
//
//  Created by SeanCho on 3/26/25.
//


import SwiftUI

struct FirestoreEncoder {
    private let encoder = JSONEncoder()
    
    func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        let data = try encoder.encode(value)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionary = jsonObject as? [String: Any] else {
            throw EncodingError.invalidValue(
                value,
                EncodingError.Context(
                    codingPath: [],
                    debugDescription: "Failed to convert encoded data to [String: Any]."
                )
            )
        }
        return dictionary
    }
}
