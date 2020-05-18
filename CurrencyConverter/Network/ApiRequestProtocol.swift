//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit
import Alamofire

/// Api Request Protocol
internal protocol ApiRequestProtocol: URLRequestConvertible {
    var apiType: ApiType { get }
    var baseUrl: URL { get }
    var url: URL { get }
    var method: HTTPMethod { get }
    var headerParameters: [String: String] { get }
    var bodyParameters: [String: Any] { get }
}

extension ApiRequestProtocol {

    var baseUrl: URL {
        return URL(string: ApiServer.defaultApiUrl)!
    }

    var url: URL {
        return baseUrl.appendingPathComponent(apiType.endPoint)
    }

    var method: HTTPMethod {
        return .get
    }

    var timeoutInterval: TimeInterval {
        return 15
    }

    var bodyParameters: [String: Any] {
        return ["access_key":ApiServer.access_key]
    }

    var headerParameters: [String: String] {
        return ["Content-Type": "application/json",
                "Authorization": "API_KEY",
                "User-Agent": userAgent]
    }

    var userAgent: String {
        let projectName = "CurrencyConverter"

        let buildNumber     = DeviceModel.bundleVersion
        let model           = UIDevice.current.model
        let systemVersion   = UIDevice.current.systemVersion
        let name            = UIDevice.current.name
        let scale           = UIScreen.main.scale
        let platform        = DeviceModel.platform

        return String(format: "%@/%@ (%@; iOS %@ %@; DeviceName/%@; Scale/%0.2f)",
                      projectName, buildNumber, model, systemVersion, platform, name, scale)
    }

    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        urlRequest.allHTTPHeaderFields = headerParameters
        
        
        switch method {
        case .get:
            return try URLEncoding.queryString.encode(urlRequest, with: bodyParameters)
        default:
            return try JSONEncoding.default.encode(urlRequest, with: bodyParameters)
        }
    }

}
