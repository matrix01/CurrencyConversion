//
//  Error.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/18/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import Foundation

/// Error
internal enum CurrencyError: Error {
    case connectionDisconnected
    case connectionTimedOut
    case connectionCanceled
    case badServerResponse
    case emptyData
    case emptyResponse

    case serverError
    case systemError(code: SystemErrorCode)
    case exceptionError(message: String)

    case fetchCurrencyFailed
    case quotesJsonDecodeFailed
    case unknown

    var localizedDescription:(title: String, message: String) {
        switch self {
        case .connectionDisconnected:
            return ("", R.string.localizable.errorConnectionDisconnectedMessage())
        case .connectionTimedOut:
            return ("", R.string.localizable.errorConnectionTimedOutMessage())
        case .connectionCanceled:
            return ("", R.string.localizable.errorConnectionCanceledMessage())
        case .badServerResponse:
            return ("", R.string.localizable.errorBadServerResponseMessage())
        case .emptyData:
            return ("", R.string.localizable.errorEmptyDataMessage())
        case .emptyResponse:
            return ("", R.string.localizable.errorEmptyResponseMessage())
        case .serverError:
            return ("", R.string.localizable.errorServerErrorMessage())
        case .exceptionError(let message):
            return ("", message)
        case .unknown:
            return ("", R.string.localizable.errorHttpStatusCodeNotSuccessMessage())
        case .fetchCurrencyFailed:
            return ("", R.string.localizable.errorCurrencyFetchFailedMessage())
        case .quotesJsonDecodeFailed:
            return ("", R.string.localizable.errorJsonNotDecodeMessage())
        case .systemError(code: let code):
            return ("", code.localizedDescription)
        }
    }

    static func errorWithSystemError(_ error: CurrencyError) -> Result<Data, CurrencyError>? {
        switch error {
        case .systemError(let code):
            switch code {
            case .notValidSubscription:
                return .failure(.systemError(code: code))
            default:
                return .failure(.unknown)
            }
        default:
            return .failure(error)
        }
    }
}

internal enum SystemErrorCode: Int {
    case notValidSubscription = 105
    case unknown

    init(_ code: Int) {
        self = SystemErrorCode(rawValue: code) ?? .unknown
    }

    var localizedDescription: String {
        switch self {
        case .notValidSubscription:
            return R.string.localizable.errorSubscriptionNotValidMessage()
        case .unknown:
            return R.string.localizable.errorSystemErrorUnknownErrorMessage()
        }
    }
}
