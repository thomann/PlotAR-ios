//
//  DatasetTableViewCell.swift
//  PlotAR
//
//  Created by Philipp Thomann on 17.12.17.
//  Copyright © 2017 Philipp Thomann. All rights reserved.
//

import UIKit

class DatasetTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
