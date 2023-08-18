//
//  StopWatchTableViewCell.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/07.
//

import UIKit

class StopWatchTableViewCell: UITableViewCell {

    @IBOutlet weak var labLbel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
