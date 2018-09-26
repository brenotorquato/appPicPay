//
//  CardTableViewCell.swift
//  PicPay
//
//  Created by Breno Torquato on 25/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCardNumber: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
