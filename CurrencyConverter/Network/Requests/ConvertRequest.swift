//
//  ConvertRequest.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/19/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Alamofire

/// Convert Request
internal struct ConvertRequest: ApiRequestProtocol {

    var apiType: ApiType = .convert

    var method: HTTPMethod = .get

    var bodyParameters: [String: Any] {
        return ["from": from,
                "to":to,
                "amount":amount,
                "access_key":ApiServer.access_key]
    }

    private var from: String
    private var to: String
    private var amount: Double

    init(from:String, to:String, amount:Double) {
        self.from = from
        self.to = to
        self.amount = amount
    }

}
