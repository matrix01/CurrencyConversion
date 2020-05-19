//
//  LiveModel.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import RealmSwift

//Live
class Live: Object, Codable {
    @objc dynamic var source: String = ""
    @objc dynamic var timestamp: Int = 0
    @objc dynamic var privacy: String = ""
    @objc dynamic var terms: String = ""
    @objc dynamic var success: Bool = false
    var quotes: [Rate] = []

    private enum CodingKeys: String, CodingKey {
        case source
        case timestamp
        case privacy
        case terms
        case success
        case quotes
    }

    required convenience public init(from decoder: Decoder) throws {
        self.init()
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

class Rate: Object, Codable {
    @objc dynamic var source: String = ""
    @objc dynamic var target: String = ""
    @objc dynamic var value: Double = 0.0
    
    required init(key:String, value: Double) {
        source = key.substring(to: 3)
        target = key.substring(from: 3)
        self.value = value
    }
    
    required init() {
        super.init()
        source = ""
        target = ""
        value = 0.0
        savedata()
    }
    
    func savedata() {
        
    }
}
