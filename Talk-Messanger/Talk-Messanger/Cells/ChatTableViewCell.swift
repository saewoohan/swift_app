//
//  ChatTableViewCell.swift
//  Talk-Messanger
//
//  Created by 한승우 on 2023/02/04.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatText: UILabel!
    @IBOutlet weak var chatimage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
