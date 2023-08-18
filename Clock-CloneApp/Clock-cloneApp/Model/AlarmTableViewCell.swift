//
//  AlarmTableViewCell.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/08.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    weak var delegate: Alarm?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func valueChanged(_ sender: UISwitch) {
        delegate?.toggle(dayLabel: dayLabel.text!, timeLabel: timeLabel.text!, isON: toggleSwitch.isOn)
    }
}
