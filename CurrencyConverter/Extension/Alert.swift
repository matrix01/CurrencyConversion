//
//  Alert.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/18/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit

struct Alert {

    static func create(title: String? = nil, message: String,
                       okActionTitle: String = R.string.localizable.commonOK(),
                       okActionHandler: (() -> Void)? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default, handler: { _ in
            okActionHandler?()
        })
        alertController.addAction(okAction)
        return alertController
    }
}
