//
//  Convertible.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/20/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation

protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType
}


extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias Element = Iterator.Element
    func mapToDomain() -> [Element.DomainType] {
        return map {
            return $0.asDomain()
        }
    }
}

extension RateRealm: DomainConvertibleType {
    typealias DomainType = Rate
    
    func asDomain() -> DomainType {
        return Rate.init(source: source, target: target, value: value)
    }
}

extension CurrencyRealm: DomainConvertibleType {
    typealias DomainType = Currency
    
    func asDomain() -> DomainType {
        return Currency.init(source: source, timestamp: timestamp, privacy: privacy, terms: terms, success: success, lastUpdate: lastUpdate, quotes: rates.mapToDomain())
    }
}
