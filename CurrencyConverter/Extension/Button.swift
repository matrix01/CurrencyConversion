//
//  UIButton.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/19/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit

public class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 1.0
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
