//
//  DetailTableViewCell.swift
//  Consolidation6
//
//  Created by Weirup, Chris on 2019-04-21.
//  Copyright © 2019 Weirup, Chris. All rights reserved.
//

import UIKit
import WebKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
