//
//  TableViewCell.swift
//  DesignApp
//
//  Created by Mac on 04/03/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
