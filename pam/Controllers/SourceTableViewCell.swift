//
//  SourceTableViewCell.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 03.05.2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit

class SourceTableViewCell: UITableViewCell {

    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
