//
//  ConvertModel.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/19/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

internal struct Convert: Codable {
    var privacy: String
    var terms: String
    var success: Bool
    var result: Double
}

internal struct ConvertError: Codable {
    var code:Int
    var info:String
}
