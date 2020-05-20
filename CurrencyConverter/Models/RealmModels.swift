//
//  RealmModels.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/20/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation
import RealmSwift

//Rate model as RateRealm
@objcMembers class RateRealm: Object, Decodable {
    dynamic var source: String = ""
    dynamic var target: String = ""
    dynamic var value: Double = 0.0
    
    init(key:String, value:Double) {
        super.init()
        source = key.substring(to: 3)
        target = key.substring(from: 3)
        self.value = value
    }
    
    required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "target"
    }
}

//Live data model as InfoRealm
@objcMembers class CurrencyRealm: Object, Decodable {
    dynamic var source: String = ""
    dynamic var timestamp: Int = 0
    dynamic var privacy: String = ""
    dynamic var terms: String = ""
    dynamic var lastUpdate: Date = Date()
    dynamic var success: Bool = false
    let rates = RealmSwift.List<RateRealm>()
    
    enum CodingKeys: String, CodingKey {
        case source
        case timestamp
        case privacy
        case terms
        case lastUpdate
        case quotes
        case success
    }
    
    override class func primaryKey() -> String? {
        return "source"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        source = try container.decode(String.self, forKey: .source)
        timestamp = try container.decode(Int.self, forKey: .timestamp)
        privacy = try container.decode(String.self, forKey: .privacy)
        terms = try container.decode(String.self, forKey: .terms)
        success = try container.decode(Bool.self, forKey: .success)
        let quotes = try container.decode([String:Double].self, forKey: .quotes).map{ dict in
            (RateRealm.init(key: dict.key, value: dict.value))
        }
        rates.append(objectsIn: quotes)
        lastUpdate = Date().addingTimeInterval(30*60)
    }
    
    required init() {
        super.init()
    }

    func save(){
        let realm = try! Realm()
        try! realm.write({
            realm.create(CurrencyRealm.self, value: self, update: .all)
        })
    }
    
    static func getInfo() -> CurrencyRealm? {
        let realm = try! Realm()
        return realm.objects(CurrencyRealm.self).first
    }
}
