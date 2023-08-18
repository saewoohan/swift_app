//
//  AlarmAddTableViewCell.swift
//  Clock-cloneApp
//
//  Created by 한승우 on 2023/01/08.
//

import UIKit

class AlarmAddTableViewCell: UITableViewCell {
    
    weak var delegate: Send?
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var switchLabel: UISwitch!
    var isON: Bool?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.borderStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        delegate?.textChange(text: sender.text!)
    }
    
    
    @IBAction func valurChanged(_ sender: UISwitch) {
        delegate?.swit(isON: switchLabel.isOn)
    }
}
