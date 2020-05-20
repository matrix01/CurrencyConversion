//
//  LiveModel.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/17/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

//Live
internal struct Currency {
    var source: String
    var timestamp: Int
    var privacy: String
    var terms: String
    var success: Bool
    var quotes: [Rate]
}

//Rate
internal struct Rate {
    var source: String
    var target: String
    var value: Double
}

//Convert
internal struct Convert: Decodable {
    var privacy: String
    var terms: String
    var success: Bool
    var result: Double
}

//Convert Error
internal struct ConvertError: Decodable {
    var code:Int
    var info:String
}

