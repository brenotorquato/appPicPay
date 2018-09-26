//
//  PersonTableViewCellCell.swift
//  PicPay
//
//  Created by Breno Torquato on 17/09/2018.
//  Copyright © 2018 Breno Torquato. All rights reserved.
//

import UIKit

class PersonTableViewCellCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupRadiusImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupRadiusImageView() {
        imgUser.layer.cornerRadius = imgUser.layer.frame.size.height / 2
        imgUser.layer.masksToBounds = false
        imgUser.clipsToBounds = true
    }
    
}
