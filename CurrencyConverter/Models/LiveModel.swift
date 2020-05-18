//
//  LiveModel.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

//Live
internal struct Live: Codable {
    var source: String
    var timestamp: Int
    var privacy: String
    var terms: String
    var success: Bool
    var quotes: [Rate]

    private enum CodingKeys: String, CodingKey {
        case source
        case timestamp
        case privacy
        case terms
        case success
        case quotes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        timestamp = try container.decode(Int.self, forKey: .timestamp)
        privacy = try container.decode(String.self, forKey: .privacy)
        terms = try container.decode(String.self, forKey: .terms)
        success = try container.decode(Bool.self, forKey: .success)
        let arrayOfRate = try container.decode([String:Double].self, forKey: .quotes).map{ dict in
            return Rate.init(key: dict.key, value: dict.value)
        }
        quotes = arrayOfRate
    }
}

internal struct Rate: Codable {
    var source: String
    var target: String
    var value: Double
    
    init(key:String, value: Double) {
        source = key.substring(to: 3)
        target = key.substring(from: 3)
        self.value = value
    }
}
