//
//  CurrencyListCell.swift
//  CurrencyConverter
//
//  Created by milan.mia on 5/18/20.
//  Copyright © 2020 fftsys. All rights reserved.
//

import UIKit

internal final class CurrencyListCell: UITableViewCell {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(rate: Rate) {
        countryLabel.text = rate.target
        rateLabel.text = "\(rate.value)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
