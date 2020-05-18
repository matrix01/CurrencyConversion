//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/16/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation
import Alamofire

typealias CurConvResultHandler = (Swift.Result<Data, CurrencyError>) -> Void

/// protocol ApiClientProtocol
protocol ApiClientProtocol {

    func request(_ request: ApiRequestProtocol, completion: @escaping CurConvResultHandler)

}

/// ApiClient
internal struct ApiClient: ApiClientProtocol { }

extension ApiClientProtocol {

    func request(_ request: ApiRequestProtocol, completion: @escaping CurConvResultHandler) {
        #if DEBUG
        print("method: \(request.method) url: \(request.url)")
        print("apiType: \(request.apiType)")
        print("headerParameters \(request.headerParameters)")
        print("bodyParameters \(request.bodyParameters)")
        #endif
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON(completionHandler: { (response) in
                if let error = self.errorWithResponse(response) {
                    completion(Swift.Result.failure(error))
                } else {
                    completion(Swift.Result.success(response.data!))
                }

                #if DEBUG
                print("response: \(String(describing: response.result))")
                #endif
        })
    }
    private func errorWithResponse(_ response: AFDataResponse<Any>) -> CurrencyError? {
        switch response.result {
        case .success:
            break
        case .failure(let error):
            let error = error as NSError
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet {
                return .connectionDisconnected
            } else if error.domain == NSURLErrorDomain && error.code == NSURLErrorTimedOut {
                return .connectionTimedOut
            } else if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                return .connectionCanceled
            } else if error.domain == NSURLErrorDomain && error.code == NSURLErrorBadServerResponse {
                return .badServerResponse
            }
        }

        guard response.data != nil else {
            return .emptyData
        }

        guard let response = response.response else {
            return .emptyResponse
        }

        switch response.statusCode {
        case 500...599:
            return .serverError
        default:
            break
        }

        return nil
    }
}


/// ApiClientStab
internal struct ApiClientStab: ApiClientProtocol {

    func request(_ request: ApiRequestProtocol, completion: @escaping CurConvResultHandler) {
        print("method: \(request.method) url: \(request.url)")
        print("bodyParameters \(request.bodyParameters)")
        var jsonData = Data()
        let timeInterval = 2.0
        do {
            switch request.apiType {
            case .live:
                jsonData = try Data(contentsOf: R.file.liveJson()!)
            default:
                break
            }
        } catch {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                completion(Swift.Result.failure(CurrencyError.emptyData))
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) {
            completion(Swift.Result.success(jsonData))
        }
    }

}
