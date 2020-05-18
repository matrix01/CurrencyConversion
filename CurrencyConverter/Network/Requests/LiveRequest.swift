//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Alamofire

/// Live Request
internal struct LiveRequest: ApiRequestProtocol {

    var apiType: ApiType = .live

    var method: HTTPMethod = .get

    init() {
        
    }

}
