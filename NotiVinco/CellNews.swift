//
//  CellNews.swift
//  NotiVinco
//
//  Created by F J Castaneda Ramos on 11/11/14.
//  Copyright (c) 2014 VincoOrbis. All rights reserved.
//

import UIKit

class CellNews: UITableViewCell {
    @IBOutlet var titulo:UILabel!
    @IBOutlet var descripcion:UILabel!
    @IBOutlet var date:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
