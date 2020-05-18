//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

/// Api Type
internal enum ApiType {
    case live
    case historical //(date: String) // YYYY-MM-DD
    case convert //(from:String, to:String)

    case timeeframe //(fromDate:String, toDate:String)
    case change
    
    var endPoint: String {
        switch self {
        case .live:
            return "/live"
        case .historical:
            return "/historical"
        case .convert:
            return "/convert"
        case .timeeframe:
            return "/timeframe"
        case .change:
            return "/change"
        }
    }
}
